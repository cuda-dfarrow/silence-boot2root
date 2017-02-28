use DBI;
use CGI;
use CGI::Session;
#use Apache;
#use Apache::Session::MySQL;
use Data::GUID;
use Text::Caml;

# Configuration
my $templatesDir = '/var/www/html/templates/';
my $mediaDir = '/var/www/html/media/';
my $sesCookieName = 'SESID';
my $outputDebug = 1;

my %dbconfig = do '/var/www/html/dbconfig.pl';

sub main {
    my $req = CGI->new;
    my $stateBag = {};
    my $sessionId = $req->cookie("$sesCookieName") || newSessionId();
    my $session = new CGI::Session(
        'driver:MySQL', 
        $sessionId, 
        { Handle=>(DBI->connect($dbconfig{conString}, $dbconfig{dbUser}, $dbconfig{dbPass})) }
    );
    
    if ($req->param("logout") eq 'y') {
        logout($session, $req);
        return;
    }
    
    if (!(defined $sessionId)) {
        $sessionId = $session->id();
        $session->flush();
    }
    
    my @array = ();
    my @peekOptions = (
        { Name=>'Paul', Value=>'psimon', Selected=>'' },
        { Name=>'Art', Value=>'agarfunkel', Selected=>'' },
    );
    $stateBag->{messages} = \@array;
    $stateBag->{username} = $session->param('username') || '';
    $stateBag->{method} = ($req->request_method() || '');
    $stateBag->{csrfToken} = $session->param("csrfToken") || '';
    $stateBag->{isAuth} = 0;
    $stateBag->{peekOptions} = \@peekOptions;
    $stateBag->{peekingAt} = $session->param("peekingAt") || 'psimon';
    $stateBag->{mediaUrl} = '/media/psimon/silence.mp3';
    
    my $csrfToken = $req->param('csrfToken') || '';
    my $isCsrfVal = validateCsrf($stateBag, $session, $req);    
    
    if ($stateBag->{csrfToken} eq '') {
        addMessage($stateBag, "Generatting CSRF");
        genCsrfToken($stateBag, $session, $req);
    }
    
    addMessage($stateBag, "Checking CSRF Token - M: " . $stateBag->{method} . " C: $isCsrfVal");
    
    if ($stateBag->{method} eq 'POST' && $isCsrfVal != 1) {
        render($stateBag, $session, $req, 'badRequest');
        return;
    }
    
    my $peekingAt = $req->param('peekAt') || '';
    if ($peekingAt ne '') {
        $session->param("peekingAt", $peekingAt);
        $stateBag->{peekingAt} = $peekingAt;
    }
    foreach $option (@peekOptions) {
        if ($option->{Value} eq $stateBag->{peekingAt}) {
            $option->{Selected} = 'selected';
        }
    }
    
    my $isAuth = checkAuth($stateBag, $session, $req);
    addMessage($stateBag, "Checking auth - A: $isAuth");
    $stateBag->{isAuth} = $isAuth;
    $stateBag->{mediaUrl} = $req->param("play") || $stateBag->{mediaUrl};
    if ($isAuth == 0) {
        addMessage($stateBag, "Bad auth");
        render($stateBag, $session, $req, 'login');
        return;
    }
    
    addMessage($stateBag, 'Dammit Paul, you need to stop reusing your passwords!');
    
    loadDirContent($stateBag, $session, $req);
    render($stateBag, $session, $req, 'default');
    return;
}

sub loadDirContent {
    my $stateBag = shift(@_);
    my $session = shift(@_);
    my $req =  shift(@_);
    
    my $peekingAt = $stateBag->{peekingAt};
    my $dir = "$mediaDir$peekingAt";
    my $listing = `ls -g -G -h -Q --time-style=iso $dir/*.mp3`;
    my @fileListLines = split /\n/, $listing;
    my @fileListing = ();
    foreach $line (@fileListLines) {
        $line =~ s|/.*/||;
        $line =~ s/-[-rwxX]+ \d //;
        my $size = $line;
        my $date = $line;
        $line =~ s/.*"(.*)"/$1/;
        $size =~ s/(\d+\w*) .*/$1/;
        $date =~ s/.* (\d\d-\d\d \d\d\:\d\d) .*/$1/;
        push @fileListing, { Name=>$line, Size=>$size, Date=>$date, Link=>"/media/$peekingAt/$line" };
    }
    $stateBag->{dirListing} = \@fileListing;
}

sub newSessionId {
    my $guid = Data::GUID->new();
    my $guidStr = $guid->as_string();
    $guidStr =~ s/\-//g;
    return $guidStr;
}

sub addMessage {
    my $stateBag = shift(@_);
    my $message = shift(@_);
    
    if ($outputDebug != 0 ) {
        my $arrRef = $stateBag->{messages}; 
        push (@$arrRef, $message);
    }
}

sub checkAuth {
    my $stateBag = shift(@_);
    my $session = shift(@_);
    my $req =  shift(@_);
    
    if ($req->param('username') ne '' && $stateBag->{method} eq 'POST') {
        #addMessage("Doing auth", $stateBag);
        doAuth($stateBag, $session, $req);
    }
    my $authVal = $session->param('authenticated') || 'n';
    addMessage($stateBag, "Auth state: $authVal");
    if ($session->param("authenticated") eq 'y') {
        return 1;
    }
    return 0;
}

sub doAuth {
    my $stateBag = shift(@_);
    my $session = shift(@_);
    my $req =  shift(@_);
    
    my $username = $req->param('username') || '';
    my $password = $req->param('password') || '';
    my $dbh = DBI->connect($dbconfig{conString}, $dbconfig{dbUser}, $dbconfig{dbPass});
    my $sth = $dbh->prepare("SELECT * FROM users WHERE id = '$username' AND pass = '$password'");
    
    $sth->execute();
    my $rowsReturned = $sth->fetchall_arrayref();
    my $numRows = @$rowsReturned;
    
    addMessage("Auth found $numRows with U:'$username' P:'$password' ");
    if ($numRows > 0) {
        $session->param('authenticated', 'y');
        $session->param('username', $username);
    } else {
        $session->param('authenticated', 'n');
    }
    $session->flush();
}

sub genCsrfToken {
    my $stateBag = shift(@_);
    my $session = shift(@_);
    my $req =  shift(@_);
    
    my $guid = Data::GUID->new();
    
    $session->param("csrfToken", $guid->as_string() );
    $session->flush();
    $stateBag->{csrfToken} = $session->param("csrfToken");
}

sub validateCsrf() {
    my $stateBag = shift(@_);
    my $session = shift(@_);
    my $req =  shift(@_);
    
    my $csrfToken = $req->param('csrfToken');
    my $csrfCheck = $session->param("csrfToken");
    
    if ( $csrfToken eq $csrfCheck ) {
        return 1;
    }
    return 0;
}

sub render {
    my $stateBag = shift(@_);
    my $session = shift(@_);
    my $req =  shift(@_);
    my $template = shift(@_); 
    
    my $view = Text::Caml->new(default_partial_extension=>'mustache');
    my $cookie = $req->cookie( "$sesCookieName" => $session->id() );
    
    print "Content-Type: text/html; charset=utf-8\x0D\x0A";
    print "Set-Cookie: $cookie; HttpOnly\x0D\x0A";
    print "X-Frame-Options: SAMEORIGIN\x0D\x0A";
    print "\x0D\x0A";
    # WTF mod_perl! - http://www.perlmonks.org/?node_id=996493
    #print $req->header(
    #    -charset=>'utf-8',
    #    -cookie=>$cookie
    #);
    $view->set_templates_path($templatesDir); 
    print $view->render_file ( "${template}.mustache", $stateBag );
    return;
}

sub logout {
    my $session = shift(@_);
    my $req =  shift(@_);
    
    $session->delete();
    
    print "Content-Type: text/html; charset=utf-8\x0D\x0A";
    print "Set-Cookie: $sesCookieName=; HttpOnly\x0D\x0A";
    print "location: index.pl\x0D\x0A";
    print "\x0D\x0A";
    
    return;
}

main();

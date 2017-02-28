<?php

$dbconn = pg_connect("
  host=localhost
  dbname=silence
  user=silence
  password=silence
") or die ('Could not connect: ' . pg_last_error());

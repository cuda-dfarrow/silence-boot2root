<?php

require_once('db.php');

if ($argc != 2) {
  die(sprintf("Usage: %s <query>", $argv[0]));
}

$query = "SELECT name, cellnum FROM users WHERE name like '%$argv[1]%'";

print("Executing: $query\n");

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

if (pg_num_rows($result)) {
  while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    print(sprintf("Name: %s, Cell: %s\n", $line['name'], $line['cellnum']));
  }
} else {
  print("No results found.\n");
}

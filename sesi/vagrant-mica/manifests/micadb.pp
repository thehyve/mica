notify {"creating mysql user/database" :}

exec { "create database":
  command => 'echo "CREATE DATABASE IF NOT EXISTS mica" | mysql -uroot', # -proot
  path    => "${binpath}",
} ->
exec { "grant usage":
  command => 'echo "GRANT USAGE ON *.* TO mica@localhost IDENTIFIED BY \'mica\'" | mysql -uroot ', #-prootpw
  path    => "${binpath}"
} ->
exec { "grant privileges":
  command => 'echo "GRANT ALL PRIVILEGES ON mica.* TO mica@localhost IDENTIFIED BY \'mica\'" | mysql -uroot ', #-prootpw
  path    => "${binpath}"
}



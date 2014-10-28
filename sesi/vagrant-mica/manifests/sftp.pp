# Use internal sftp, as this stripped-down image does not include the external one.
exec { "/bin/sed -i 's/Subsystem sftp .*/Subsystem sftp internal-sftp/g' /etc/ssh/sshd_config":
  notify => Service["sshd"],
}

service { "sshd":
  ensure  => "running",
  enable  => "true",
}

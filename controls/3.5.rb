# frozen_string_literal: true

control '3.5' do
  title "Ensure 'relay_log_basename' Files Have Appropriate Permissions and Ownership (Scored)"
  desc  "MySQL can operate using a variety of log files, each used for different purposes.
  These are the binary log, error log, slow query log, relay log, audit log and general log.
  Because these are files on the host operating system, they are subject to the permissions and ownership structure provided
  by the host and may be accessible by users other than the MySQL user"
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '3.5'
  tag "cis_level": 1
  tag "nist": %w[AU-9 Rev_4]
  tag "Profile Applicability": 'Level 1 - MySQL RDBMS on Linux'
  tag "audit text": "Perform the following steps to assess this recommendation:
  • Execute the following SQL statement to determine the Value of relay_log_basename
    show variables like 'relay_log_basename';
  • Execute the following command at a terminal prompt to list all relay_log_basename.* files
    ls <relay_log_basename>.*
  • For each file listed, execute the following command
    ls -l <relay_log_basename> | egrep '^-[r|w]{2}-[r|w]{2}----\s*.*$'
  Lack of output implies a finding"
  tag "fix": "Execute the following command for each log file location requiring corrected permissions and ownership:
      chmod 660 <log file>
      chown mysql:mysql <log file>"

  query = %(select @@relay_log_basename;)

  sql_session = mysql_session(input('user'), input('password'), input('host'), input('port'))

  relay_log_basename = sql_session.query(query).stdout.strip.split.first

  only_if("#{relay_log_basename} directory exist.") do
    directory(relay_log_basename).exist?
  end

  describe directory(relay_log_basename.to_s) do
    it { should exist }
    its('owner') { should eq 'mysql' }
    its('group') { should eq 'mysql' }
    its('mode') { should be <= 0o660 }
  end
  only_if { os.linux? }
end

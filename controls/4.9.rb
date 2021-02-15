# frozen_string_literal: true

control '4.9' do
  title "Ensure 'sql_mode' Contains 'STRICT_ALL_TABLES' (Scored)"
  desc  "When data changing statements are made (i.e. INSERT, UPDATE), MySQL can handle invalid or missing values differently depending on whether strict SQL mode is enabled.
        When strict SQL mode is enabled, data may not be truncated or otherwise 'adjusted' to make the data changing statement work"
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '4.9'
  tag "cis_level": 2
  tag "nist": %w[AC-6 Rev_4]
  tag "Profile Applicability": 'Level 2 - MySQL RDBMS'
  tag "audit text": "To audit for this recommendation execute the following query:
      SHOW VARIABLES LIKE 'sql_mode';
      Ensure that STRICT_ALL_TABLES is in the list returned."
  tag "fix": "Perform the following actions to remediate this setting:
      1. Add STRICT_ALL_TABLES to the sql_mode in the server's configuration file"

  sql_mode = mysql_session(
             input('user'), input('password'), input('host')
             ).query("SELECT @@sql_mode;").stdout.strip
  puts "SELECT @@sql_mode; = #{sql_mode}"
  describe 'The sql_mode' do
    subject { sql_mode }
    it { should include 'STRICT_ALL_TABLES' }
  end
end

# frozen_string_literal: true

control '6.12' do
  title "Make sure the audit plugin can't be unloaded (Scored)"
  desc  'Set audit_log to FORCE_PLUS_PERMANENT'
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '6.12'
  tag "cis_level": 1
  tag "nist": %w[AU-2 Rev_4]
  tag "Profile Applicability": 'Level 1 - MySQL RDBMS'
  tag "audit text": "To assess this recommendation, execute the following SQL statement:
    SELECT LOAD_OPTION FROM information_schema.plugins WHERE PLUGIN_NAME='audit_log';
  The result must be FORCE_PLUS_PERMANENT"
  tag "fix": "To remediate this setting, follow these steps:
  1. Open the MySQL configuration file (my.cnf)
  2. Ensure the following line is found in the mysqld section
  audit_log = 'FORCE_PLUS_PERMANENT'"
  tag "Default Value": 'ON'

  query = %(SELECT LOAD_OPTION FROM information_schema.plugins WHERE PLUGIN_NAME='audit_log';)
  sql_session = mysql_session(input('user'), input('password'), input('host'), input('port'))

  audit_log_plugin = sql_session.query(query).stdout.strip

  describe 'The MySQL audit plugin' do
    subject { audit_log_plugin }
    it { should cmp 'FORCE_PLUS_PERMANENT' }
  end

  describe mysql_conf do
    its('mysqld.audit_log') { should cmp 'FORCE_PLUS_PERMANENT' }
  end
end

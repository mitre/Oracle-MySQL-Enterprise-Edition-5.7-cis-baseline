# frozen_string_literal: true

control '6.8' do
  title 'Ensure audit_log_policy is set to log logins (Scored)'
  desc  'With the audit_log_policy setting the amount of information which is sent to the audit log is controlled. It must be set to log logins.'
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '6.8'
  tag "cis_level": 1
  tag "nist": %w[AU-2 Rev_4]
  tag "Profile Applicability": 'Level 1 - MySQL RDBMS'
  tag "audit text": "SHOW GLOBAL VARIABLES LIKE 'audit_log_policy';
  The result must be LOGINS or ALL."
  tag "fix": "Set audit_log_policy='ALL' or audit_log_policy='LOGINS' in the MySQL configuration file and activate the setting by restarting the server or executing
   SET GLOBAL audit_log_policy='ALL'; or SET GLOBAL audit_log_policy='LOGINS';"
  tag "Default Value": 'ALL'

  audit_log_policy = mysql_session(
    input('user'), input('password'), input('host'), input('port')
  ).query("SELECT @@audit_log_policy;").stdout.strip
  puts "audit_log_policy = #{audit_log_policy}"
  describe.one do
    describe 'The MySQL audit_log_policy' do
      subject { audit_log_policy }
      it { should eq 'ALL' }
    end
    describe 'The MySQL audit_log_policy' do
      subject { audit_log_policyy }
      it { should eq 'LOGINS' }
    end
  end
end

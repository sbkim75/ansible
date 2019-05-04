import java.util.*;
import sinsiway.*;


public class PcaTest extends Thread {

	private String ClientIP;        // client IP
	private String UserID;          // client virtual user ID
	private String ClientProgram;   // client program name

	private void privateSessionID(String src) throws Exception
	{
        	sinsiway.PcaSession session = sinsiway.PcaPool.getSession(ClientIP, UserID, ClientProgram);
	        String org_enc_data = ("TrwMHq0RltNZfsb2jjvBLQAA==AA0A");
		System.out.println(" * ORG Encrypt DATA : "+org_enc_data);
        	String decrypted_data = session.decrypt(1, org_enc_data);
       		System.out.println(" * ORG Decrypt DATA : "+decrypted_data);
/*
	        sinsiway.PcaSessionPoolS.initialize("/var/tmp/.petra/petra_cipher_api.conf","");
        	sinsiway.PcaSessionS sessions = sinsiway.PcaSessionPoolS.getSession(ClientIP, UserID, ClientProgram);
	        String  encrypted_data = sessions.encrypt(500, decrypted_data);
	        System.out.println(" * NEW Encrypt DATA : "+encrypted_data);*/
	}

	public PcaTest(String client_ip,String user_id, String client_program)
	{
		if (client_ip == null) ClientIP = new String("");
                else ClientIP = new String(client_ip);
                if (user_id == null) UserID = new String("");
                else UserID = user_id; 
                if (client_program == null) ClientProgram = new String("");
                else ClientProgram = new String(client_program);
	}
	public void run()
	{
		try {
			privateSessionID("01033363553");
		} catch(Exception e) {
			e.printStackTrace();
			return;
		}
	}

	public static void main(String[] args) 
	{
		PcaTest	pca_test = new PcaTest("172.27.104.228","ssw","api");
		pca_test.start();
	}

/*
	static {
		try {
			sinsiway.PcaSessionPool.initialize("./petra_cipher_api.conf","");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
*/

}

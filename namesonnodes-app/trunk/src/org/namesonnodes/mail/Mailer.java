package org.namesonnodes.mail;

import java.util.Date;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public final class Mailer
{
	public static boolean testMode = false;
	public static final String SENDER = "noreply@namesonnodes.org";
	public static final String SIGNATURE = "--\r\nT. Michael Keesey, Creator of NAMES ON NODES\r\nhttp://namesonnodes.org/\r\nhttp://3lbmonkeybrain.blogspot.com/\r\nkeesey@gmail.com\r\n";
	public static final String SUBJECT_PREFIX = "Names on Nodes: ";
	public static void send(final String recipient, final String subject, final String message)
	        throws AddressException, MessagingException
	{
		if (testMode)
		{
			System.out.println("[WARNING] Skipping the following email:");
			System.out.println("To: " + recipient);
			System.out.println("Subject: " + subject);
			System.out.println("--------");
			System.out.println(message);
			System.out.println("--------");
			return;
		}
		// Set the host SMTP address.
		final Properties props = new Properties();
		props.put("mail.from", SENDER);
		props.put("mail.smtp.host", "localhost");
		props.put("mail.smtp.port", "25");
		// Create some properties and get the default session.
		final Session session = Session.getDefaultInstance(props, null);
		session.setDebug(true);
		// Create a message.
		final Message msg = new MimeMessage(session);
		// Set the from and to addresses.
		final InternetAddress senderAddress = new InternetAddress(SENDER);
		msg.setFrom(senderAddress);
		final InternetAddress recipientAddress = new InternetAddress(recipient);
		msg.setRecipient(RecipientType.TO, recipientAddress);
		// Set the subject and content type.
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		msg.setContent(message, "text/plain");
		// Send the message.
		Transport.send(msg);
	}
	private Mailer()
	{
	}
}

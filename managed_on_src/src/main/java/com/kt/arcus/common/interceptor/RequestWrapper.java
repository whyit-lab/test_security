package com.kt.arcus.common.interceptor;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.regex.Pattern;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import org.apache.commons.io.IOUtils;

public class RequestWrapper extends HttpServletRequestWrapper {
	private byte[] b;

	private static final Pattern scriptPattern = Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE);
	private static final Pattern srcPatternSingleQuote = Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
	private static final Pattern srcPatternDoubleQuote = Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
	private static final Pattern scriptEndPattern = Pattern.compile("</script>", Pattern.CASE_INSENSITIVE);
	private static final Pattern scriptPattern2 = Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
	private static final Pattern evalPattern = Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
	private static final Pattern expPattern = Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
	private static final Pattern jsPattern1 = Pattern.compile("javascript:.*\\)", Pattern.CASE_INSENSITIVE);
	private static final Pattern jsPatternGeneral = Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE);
	private static final Pattern vbPattern = Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE);
	private static final Pattern onloadPattern = Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
	private static final Pattern onpointerPattern = Pattern.compile("(?i)<[^>]*\\bonpointer\\b[^>]*>");
	private static final Pattern ontogglePattern = Pattern.compile("(?i)<[^>]*\\bontoggle\\b[^>]*>");
	private static final Pattern iframePattern = Pattern.compile("(?i)<iframe\\b[^>]*>");

	private static final String[] filterStrings = {
		// "javascript",		// ignore simple patterns
		// "vbscript",
		// "expression",
		// "applet",
		// "meta",
		// "xml",
		// "blink",
		// "link",
		// "style",
		// "script",
		// "embed",
		// "object",
		// "iframe",
		// "frame",
		// "fr",
		// "ameset",
		// "ilayer",
		// "layer",
		// "bgsound",
		// "title",
		// "base",
		// "eval",
		// "innerHTML",
		// "charset",
		// "document",
		// "string",
		// "create",
		// "append",
		// "bin",
		// "ding",
		// "alert",
		// "msgbox",
		// "refresh",
		// "cookie",
		// "void",
		// "href",
		"onabort",				// filter event keywords
		"onactivae",
		"onafterprint",
		"onafterupdate",
		"onbefore",
		"onbeforeactivate",
		"onbeforecopy",
		"onbeforecut",
		"onbeforedeactivate",
		"onbeforeeditfocus",
		"onbeforepaste",
		"onbeforeprint",
		"onbeforeunload",
		"onbeforeupdate",
		"onblur",
		"onbounce",
		"oncellchange",
		"onchange",
		"onclick",
		"oncontextmenu",
		"oncontrolselect",
		"oncopy",
		"oncut",
		"ondataavailable",
		"ondatasetchanged",
		"ondatas",
		"etcomplete",
		"ondblclick",
		"ondeactivate",
		"ondrag",
		"ondragend",
		"ondragenter",
		"ondragleave",
		"ondragover",
		"ondragstart",
		"ondrop",
		"onerror",
		"onerrorupdate",
		"onfilterchange",
		"onfinish",
		"onfocus",
		"onfocusin",
		"onfocusout",
		"onhelp",
		"onkeydown",
		"onkeypress",
		"onkeyup",
		"onlayoutcomplete",
		"onload",
		"onlosecapture",
		"onmousedown",
		"onmouseenter",
		"onmouseleave",
		"onmousemove",
		"onmouseout",
		"onmouseover",
		"onmouseup",
		"onmousewheel",
		"onmove",
		"onmoveend",
		"onmovestart",
		"onpaste",
		"onpropertychange",
		"onreadystatechange",
		"onreset",
		"onresize",
		"onresizeend",
		"onresizestart",
		"onrowenter",
		"onrowexit",
		"onrowsdelete",
		"onrowsinserted",
		"onscroll",
		"onselect",
		"onselectionchange",
		"onselectstart",
		"onstart",
		"onstop",
		"onsubmit",
		"onunload"
	};

	private String stripXSS(String value) {
		if (value != null) {
			value = value.replaceAll("", "");

			value = scriptPattern.matcher(value).replaceAll("");
			value = srcPatternSingleQuote.matcher(value).replaceAll("");
			value = srcPatternDoubleQuote.matcher(value).replaceAll("");
			value = scriptEndPattern.matcher(value).replaceAll("");
			value = scriptPattern2.matcher(value).replaceAll("");
			value = evalPattern.matcher(value).replaceAll("");
			value = expPattern.matcher(value).replaceAll("");
			value = jsPattern1.matcher(value).replaceAll("");
			value = jsPatternGeneral.matcher(value).replaceAll("");
			value = vbPattern.matcher(value).replaceAll("");
			value = onloadPattern.matcher(value).replaceAll("");
			value = onpointerPattern.matcher(value).replaceAll("");
			value = ontogglePattern.matcher(value).replaceAll("");
			value = iframePattern.matcher(value).replaceAll("");

			for (String token : filterStrings) {
				value = value.replace(token, "_" + token + "_");
			}
		}
		return value;
	}

	public RequestWrapper(HttpServletRequest request) throws IOException {
		super(request);
		// // XssFilter filter = XssFilter.getInstance("lucy-xss-superset.xml");
		// String body = getBody(request);
		// // String filtered = new String(filter.doFilter(body));
		// String filtered = stripXSS(body);
		// b = filtered.getBytes();
		// // b = new String(filter.doFilter(getBody(request))).getBytes();

 		b = new String(stripXSS(getBody(request))).getBytes();
	}

	public ServletInputStream getInputStream() throws IOException {
 		final ByteArrayInputStream bis = new ByteArrayInputStream(b);
 		return new ServletInputStreamImpl(bis);
 	}

 	class ServletInputStreamImpl extends ServletInputStream{
 		private InputStream is;

 		public ServletInputStreamImpl(InputStream bis){
 			is = bis;
 		}

 		public int read() throws IOException {
 			return is.read();
 		}

 		public int read(byte[] b) throws IOException {
 			return is.read(b);
 		}

		@Override
		public boolean isFinished() {
			return false;
		}

		@Override
		public boolean isReady() {
			return false;
		}

		@Override
		public void setReadListener(ReadListener readListener) {
		}
 	}

 	public static String getBody(HttpServletRequest request) throws IOException {
 	    String body = null;
 	    StringBuilder stringBuilder = new StringBuilder();
 	    BufferedReader bufferedReader = null;

 	    try {
 	        InputStream inputStream = request.getInputStream();
 	        if (inputStream != null) {
 	            bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
 	            char[] charBuffer = new char[128];
 	            int bytesRead = -1;
 	            while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
 	                stringBuilder.append(charBuffer, 0, bytesRead);
 	            }
 	        } else {
 	            stringBuilder.append("");
 	        }
 	    } catch (IOException ex) {
 	        throw ex;
 	    } finally {
 	        if (bufferedReader != null) {
 	            try {
 	                bufferedReader.close();
 	            } catch (IOException ex) {
 	                throw ex;
 	            }
 	        }
 	    }

 	    body = stringBuilder.toString();
 	    return body;
 	}
}
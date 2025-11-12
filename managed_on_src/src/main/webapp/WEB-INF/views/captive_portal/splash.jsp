<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication var="authData" property="principal"/>
<!DOCTYPE html>

<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<head>
    <jsp:include page="/WEB-INF/views/includes/common_head.jsp"></jsp:include>
    <!-- Optionally, you can add additional <script> or <link> tags here -->
</head>

<button id="btn_click" type="button">Click Through</button>
<a href='' id="a_link">click through link</a>
<iframe id="fm_hidden">
</iframe>

<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<script src="/static/dist/js/base/datatable_setting.js"></script>
<script>
function getParam(sname) {
	var params = location.search.substr(location.search.indexOf("?") + 1);
	var sval = "";
	params = params.split("&");

	for (var i = 0; i < params.length; i++) {
		temp = params[i].split("=");
		if ([temp[0]] == sname) { sval = temp[1]; }
	}

	return sval;
}

$(document).ready(function() {
    var base_grant_url = unescape(getParam('base_grant_url'))
    
    function isSafeUrl(url) {
        try {
            var parsed = new URL(url, window.location.origin);
            return (parsed.protocol === 'http:' || parsed.protocol === 'https:');
        } catch (error) {
            return false;
        }
    }

    if (!isSafeUrl(base_grant_url)) {
        $('#a_link').attr('href', base_grant_url);
    } else {
        $('#a_link').attr('href', '#');
    }

    $('#btn_click').click(function () {
        if (isSafeUrl(base_grant_url)) {
            $('#fm_hidden').attr('src', base_grant_url);
        } else {
            $('#fm_hidden').attr('src', 'about:blank');
        }
    });
})
</script>

</body>
</html>
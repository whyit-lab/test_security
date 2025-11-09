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
	<link rel="stylesheet" href="/css/font-awesome-4.7.0/css/font-awesome.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/admin-lte/2.3.11/js/app.min.js"></script>
</head>
<jsp:include page="/WEB-INF/views/includes/header.jsp"></jsp:include>

<div class="static-content">
	<div class="page-content">
		<!-- Content Header (Page header) -->
		<ol class="breadcrumb">
			<li><a href="/home">Home</a></li>
			<li class="active">Test Service</li>
		</ol>
		<div class="page-heading">
			<h1>
                AI Prediction
            </h1>
		</div>

		<!--------------------------
		| Your Page Content Here |
		-------------------------->
<%-- <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> --%>
<b>fbprohet</b><div style="float:right"><a href="javascript:predict();"><img src="/images/white.png"/></a></div><br><br>
device_id <select name="firstCode" id="firstCode" style="width:100px">
	<option value="171">171</option>
</select>
type <select name="secondCode" id="secondCode" style="width:250px">
	<option value="port-id756">port-id756</option>
</select>
item <select name="thirdCode" id="thirdCode" style="width:200px">
	<option value="ifOutOctets_rate">ifOutOctets_rate</option>
</select><br>
from <input type="text" id="stdt" name="stdt" value='2019-08-15'> ~ to <input type="text" id="endt" name="endt" value='2019-08-24'>&nbsp;&nbsp;&nbsp;
<input type="button" id="button1" value="Predict" disabled />&nbsp;&nbsp;&nbsp;<input type="button" id="button5" value="Logging"/>&nbsp;&nbsp;&nbsp;<input type="button" id="button4" value="Dashboard"/>&nbsp;&nbsp;&nbsp;<input type="button" id="button6" value="Detecting"/><br><p>
<input type="button" id="button2" value="Predict Graph"/> <b>(time : utc)</b><br>
<img id="image" height="400" width="800" /><br><p>
<input type="button" id="button3" value="Predict Data"/> <b>(ds : utc)</b><br>
	<table class="display" id="example" style="width: 100%;">
		<thead>
			<tr>
				<th>id</th>
				<th>ds</th>
				<th>yhat</th>
				<th>yhat_lower</th>
				<th>yhat_upper</th>
				<th>y</th>
			</tr>
		</thead>
	</table>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<!--  <script type="text/javascript" src="http://code.jquery.com/jquery.js"></script>-->



        <div class="container-fluid">                          
            <div data-widget-group="group1" id="bordered-row">
                <div class="d-sm-flex">
                    <div class="col-md-12">
                        <div class="panel panel-default">
                            <a target="_blank" href="http://210.116.92.215/monitoring/traffic/prophetViw.do">Open PortaSIEM Demo</a>
                        </div>
                    </div>
                </div>
            </div>
		</div> <!-- .container-fluid -->
	</div> <!-- #page-content -->
</div>


<jsp:include page="/WEB-INF/views/includes/footer.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/includes/footer_script.jsp"></jsp:include>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
<script src="/static/dist/js/base/datatable_setting.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script>
var server_ip = "<spring:eval expression="@configProp.getProperty('server.ip')" />";
var server_port = "<spring:eval expression="@configProp.getProperty('server.port')" />"; 

$(document).ready(function() {
	var stdt = new Date();
	stdt.setDate(stdt.getDate()-1);
	//stdt.setDate(stdt.getDate()-7);
	$('#stdt').val(dateToYYYYMMDD(stdt));

	var endt = new Date();
	endt.setDate(endt.getDate()-1);
	//endt.setDate(endt.getDate());
	$('#endt').val(dateToYYYYMMDD(endt));

	//function getFirstCode(){
		var query = {
		  "size": 0,
		  "aggs": {
			"agg1": {
			  "terms": {
				"field": "device_id"
			  }
			}
		  }
		}

		var firstArray = new Array();
		var firstObject;
		var secondArray = new Array();
		var secondObject;
		var thirdArray = new Array();
		var thirdObject;
		var firstSelectValue;
		var secondSelectValue;

		$.ajax({
			method: "POST",
			//url: "http://210.116.92.212:9200/porta_snmp_new/_search?pretty=true",
			//url: "http://61.36.41.77:9200/porta_snmp_new/_search?pretty=true",
			url: "http://" + server_ip + ":" + server_port + "/api/api/getDocById.do",
			crossDomain: true,
			async: false,
			//data: JSON.stringify(query),
			data: "idx=porta_snmp_new&q=" + JSON.stringify(query),
			//dataType: 'json',
			//contentType: 'application/json',
		})
		.done(function(data){
			//console.log(data);
			data = JSON.parse(data);
			$(data.aggregations.agg1.buckets).each(function(index, bucket){
				//console.log(bucket.key);
				result = bucket.key;
				console.log(result);
				firstObject = new Object();
				firstObject.main_category_id = result;
				firstObject.main_category_name = result;
				firstArray.push(firstObject);						

			});
		})
		.fail(function(data){
			console.log(data);
		});			
		
		var firstSelectBox = $("select[name='firstCode']");
		for(var i = 0; i < firstArray.length; i++){
			firstSelectBox.append("<option value='" + firstArray[i].main_category_id + "'>" + firstArray[i].main_category_name + "</option>");
		}
	//}

	$(document).on("change", "select[name='firstCode']", function(){
	//function getSecondCode(){
		var secondSelectBox = $("select[name='secondCode']");
		secondSelectBox.children().remove();

		$("option:selected", this).each(function(){
			var firstSelectValue = $(this).val();
			console.log(firstSelectValue);


			var query = {
			  "size": 0,
			  "query": {
				"bool": {
				  "must": [
					{
					  "match": {
						"device_id": firstSelectValue
					  }
					}
				  ]
				}
			  },
			  "aggs": {
				"agg1": {
				  "terms": {
					"field": "type.keyword",
					"size": 100
				  }
				}
			  }
			}
			console.log(JSON.stringify(query));
			$.ajax({
				method: "POST",
				//url: "http://210.116.92.212:9200/porta_snmp_new/_search?pretty=true",
				//url: "http://61.36.41.77:9200/porta_snmp_new/_search?pretty=true",
				url: "http://" + server_ip + ":" + server_port + "/api/api/getDocById.do",
				crossDomain: true,
				async: false,
				//data: JSON.stringify(query),
				data: "idx=porta_snmp_new&q=" + JSON.stringify(query),
				//dataType: 'json',
				//contentType: 'application/json',
			})
			.done(function(data){
				//console.log(data);
				data = JSON.parse(data);
				$(data.aggregations.agg1.buckets).each(function(index, bucket){
					//console.log(bucket.key);
					result = bucket.key;
					secondObject = new Object();
					secondObject.main_category_id = firstSelectValue;
					secondObject.sub_category_id = result
					secondObject.sub_category_name = result;
					secondArray.push(secondObject);
				});


			})
			.fail(function(data){
				console.log(data);
			});		
			
			secondSelectBox.append("<option value=''>All</option>");
			for(var i = 0; secondArray.length; i++){
				if(firstSelectValue == secondArray[i].main_category_id){
					secondSelectBox.append("<option value='" + secondArray[i].sub_category_id + "'>" + secondArray[i].sub_category_name + "</option>");
				}
			}
		
		});

	});

	$(document).on("change", "select[name='secondCode']", function(){
	//function getSecondCode(){
		var thirdSelectBox = $("select[name='thirdCode']");
		thirdSelectBox.children().remove();

		$("option:selected", this).each(function(){
			var secondSelectValue = $(this).val();
			console.log(secondSelectValue);


			var query = {
			  "size": 0,
			  "query": {
				"bool": {
				  "must": [
					{
					  "term": {
						"type.keyword": secondSelectValue
					  }
					},
					{
					  "range": {
						  "utcTime": {
						 	"gte": "now-5m/m",
						 	"lt": "now"
						  }
					  }
					}
				  ]
				}
			  },
			  "aggs": {
				"agg1": {
				  "terms": {
					"field": "temp.keyword",
					"size": 100
				  }
				}
			  }
			}
			console.log(JSON.stringify(query));
			$.ajax({
				method: "POST",
				//url: "http://210.116.92.212:9200/porta_snmp_new/_search?pretty=true",
				//url: "http://61.36.41.77:9200/porta_snmp_new/_search?pretty=true",
				url: "http://" + server_ip + ":" + server_port + "/api/api/getDocById.do",						
				crossDomain: true,
				async: false,
				//data: JSON.stringify(query),
				data: "idx=porta_snmp_new&q=" + JSON.stringify(query),
				//dataType: 'json',
				//contentType: 'application/json',
			})
			.done(function(data){
				console.log(data);
				data = JSON.parse(data);
				$(data.aggregations.agg1.buckets).each(function(index, bucket){
					//console.log(bucket.key);
					result = bucket.key;
					thirdObject = new Object();
					thirdObject.main_category_id = secondSelectValue;
					thirdObject.sub_category_id = result
					thirdObject.sub_category_name = result;
					thirdArray.push(thirdObject);
				});


			})
			.fail(function(data){
				console.log(data);
			});		
			
			thirdSelectBox.append("<option value=''>All</option>");
			for(var i = 0; thirdArray.length; i++){
				if(secondSelectValue == thirdArray[i].main_category_id){
					thirdSelectBox.append("<option value='" + thirdArray[i].sub_category_id + "'>" + thirdArray[i].sub_category_name + "</option>");
				}
			}
		
		});

	});

	$("#button1").click(function(){
		//console.log($('#firstCode option:selected').val());
		//console.log($('#secondCode option:selected').val());		
		//console.log($('#thirdCode option:selected').val());
		device_id = $('#firstCode option:selected').val();
		type = $('#secondCode option:selected').val();
		item = $('#thirdCode option:selected').val();
		console.log(device_id + ',' + type + ',' + item);
		stdt = $('#stdt').val();
		endt = $('#endt').val();
		console.log(stdt + ',' + endt);
		$.ajax({
				method: "POST",
				//url: "http://210.116.92.215:3306",
				url: "http://210.116.92.214:18700",
				crossDomain: true,
				async: false,
				data: {'device_id': device_id, 'type': type, 'item': item, 'stdt': stdt, 'endt': endt},
				dataType: 'json',
				contentType: 'application/json',
			})
			.done(function(data){
				console.log(data);
				alert(data['message']);

			})
			.fail(function(data){
				console.log(data);
			});
	});

	$("#button2").click(function(){
		init();
	});

	$("#button3").click(function(){
		datatable();
	});
	
	$("#button4").click(function(){
		dashboard();
	});
	
	$("#button5").click(function(){
		logging();
	});

	$("#button6").click(function(){
		detecting();
	});

});

function predict(){
	$('#button1').click();
	//document.getElementById("button1").click();
}

function logging(){
	//var url = "http://210.116.92.215:8080";
	//var url = "http://210.116.92.214:80";
	//window.open(url, "", "width=800,height=600,left=600");
	var url = "http://210.116.92.215:3000/d/E7-aInhZk/porta_logger?refresh=5s&orgId=1&panelId=2&fullscreen&var-log_type=anom-predict&theme=light&kiosk=1&from=now-6h&to=now";
	window.open(url, "", "width=1200,height=600,left=600");
}

function detecting(){
	//var url = "http://210.116.92.215:80";
	//var url = "http://210.116.92.214:4200";
	//window.open(url, "", "width=800,height=600,left=600");
	var url = "http://210.116.92.215:3000/d/E7-aInhZk/porta_logger?refresh=5s&orgId=1&panelId=2&fullscreen&var-log_type=anom-detect&theme=light&kiosk=1&from=now-1h&to=now";
	window.open(url, "", "width=1200,height=600,left=600");
}

function dashboard(){
	device_id = $('#firstCode option:selected').val();
	type = $('#secondCode option:selected').val();
	item = $('#thirdCode option:selected').val();
	//var url = "http://210.116.92.213:3000/d/kZHQuVKWz/fbprophet?orgId=1&var-aaa=" + device_id + "&var-bbb=" + type + "&var-ccc=" + item + "&theme=light&kiosk=1&refresh=5s&from=now-24h&to=now";
	var url = "http://210.116.92.215:3000/d/kZHQuVKWz/fbprophet?orgId=1&var-device_id=" + device_id + "&var-type=" + type + "&var-item=" + item + "&theme=light&kiosk=1&refresh=5s&from=now-24h&to=now";
	window.open(url, "", "width=800,height=600,left=600");

}

var i = 0;
var table;
function datatable(){
	item = $('#thirdCode option:selected').val();
	if(i == 0){
		table = $('#example').DataTable({
			//"ajax": "http://210.116.92.215:3306/get_json?item=" + item,
			"ajax": "http://210.116.92.214:18700/get_json?item=" + item,
			"columns": [
				{ "data": "id" },
				{ "data": "ds" },
				{ "data": "yhat" },
				{ "data": "yhat_lower" },
				{ "data": "yhat_upper" },
				{ "data": "y" }
			]
		});
		i = i + 1;
	}else{
		table.destroy();
		table = $('#example').DataTable({
			//"ajax": "http://210.116.92.215:3306/get_json?item=" + item,
			"ajax": "http://210.116.92.214:18700/get_json?item=" + item,
			"columns": [
				{ "data": "id" },
				{ "data": "ds" },
				{ "data": "yhat" },
				{ "data": "yhat_lower" },
				{ "data": "yhat_upper" },
				{ "data": "y" }
			]
		});
		i = i + 1;
	}
	
}

function init()
{
	item = $('#thirdCode option:selected').val();
    var xmlHTTP = new XMLHttpRequest();
    //xmlHTTP.open('GET','http://210.116.92.215:3306/get_image?item=' + item,true);
    xmlHTTP.open('GET','http://210.116.92.214:18700/get_image?item=' + item,true);

    // Must include this line - specifies the response type we want
    xmlHTTP.responseType = 'arraybuffer';

    xmlHTTP.onload = function(e)
    {

        var arr = new Uint8Array(this.response);


        // Convert the int array to a binary string
        // We have to use apply() as we are converting an *array*
        // and String.fromCharCode() takes one or more single values, not
        // an array.
        var raw = String.fromCharCode.apply(null,arr);

        // This works!!!
        var b64=btoa(raw);
        var dataURL="data:image/png;base64,"+b64;
        document.getElementById("image").src = dataURL;
    };

    xmlHTTP.send();
}

function dateToYYYYMMDD(date){
    function pad(num) {
        num = num + '';
        return num.length < 2 ? '0' + num : num;
    }
    return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate());
}


</script>



</body>
</html>
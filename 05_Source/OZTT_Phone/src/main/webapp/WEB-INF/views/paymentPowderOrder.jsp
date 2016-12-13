<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title><fmt:message key="PAYMENT_TITLE" /></title>
  <script type="text/javascript">
  		var E0007 = '<fmt:message key="E0007" />';
  		$(function(){
  			checkShowBtn();
  		});
  		
  		function checkShowBtn(){
  			if ($("#vpc_AccessCode").val() == "" || 
  					$("#vpc_MerchTxnRef").val() == "" || 
  					$("#vpc_Merchant").val() == "" ||
  					$("#vpc_CardNum").val() == "" || 
  					$("#vpc_CardExp").val() == "" || 
  					$("#vpc_CardSecurityCode").val() == ""){
  				$("#payBtn").css({
  					"background" : "#D4D4D4",
  				});
  				$("#payBtn").attr("onclick", "");
  			} else {
  				$("#payBtn").css({
  					"background" : "#FA6D72",
  				});
  				$("#payBtn").attr("onclick", "toPay()");
  			}
  		}
  		
  		function toPay(){
  			$("#payBtn").attr("onclick", "");
  			var paramData = {
					"vpc_CardNum":$("#vpc_CardNum").val(),
					"vpc_CardExp":$("#vpc_CardExp").val(),
					"vpc_CardSecurityCode":$("#vpc_CardSecurityCode").val(),
					"orderNo":$("#orderNo").val()
			}
	  		$.ajax({
				type : "POST",
				contentType:'application/json',
				url : '${ctx}/milkPowderAutoPurchase/toPay',
				dataType : "json",
				async : false,
				data : JSON.stringify(paramData), 
				success : function(data) {
					if (!data.isException) {
						// 付款成功
						createInfoDialog('<fmt:message key="I0007"/>','1');
						setTimeout(function() {
							location.href = "${ctx}/user/init";
						}, 1000);
					} else {
						// 付款失败
						createErrorInfoDialog('<fmt:message key="E0021"/>');
					}
					
				},
				error : function(data) {
					
				}
			});
  			$("#payBtn").attr("onclick", "toPay()");
  		}
  		
  		function blurCardExp(){
  			var cardexp = $("#vpc_CardExp").val();
  			if (cardexp == null || cardexp.length == 0) {
  				return;
  			}
  			if (cardexp.length < 4){
  				checkShowBtn();
  				return;
  			}
  			if (cardexp.length == 5 && cardexp.indexOf("/") == -1) {
  				$("#vpc_CardExp").val("");
  				checkShowBtn();
  				return;
  			}
  			
  			if (cardexp.length == 4){
  				if (isNaN(cardexp)) {
  					$("#vpc_CardExp").val("");
  	  				checkShowBtn();
  	  				return;
  				} else {
  					$("#vpc_CardExp").val(cardexp.substring(0,2) + "/" + cardexp.substring(2))
  					checkShowBtn();
  	  				return;
  				}
  			}
  		}
  		
  	// 创建信息提示框
  		function createInfoDialog(msg, type) {
  			var strHtml = '<div class="dialog-container">';
  			strHtml += '<div class="dialog-window">';
  			strHtml += '<div class="dialog-content">'+msg+'</div>';
  			strHtml += '<div class="dialog-footer">';
  			strHtml += '</div>';
  			strHtml += '</div>';
  			strHtml += '</div>';
  			$('body').append(strHtml);
  			if (type == '1') {
  				// 并在3秒后消失
  				setTimeout(function() {
  					$('.dialog-container').remove();
  				}, 1000);
  			}
  		}
  		
  		// 创建信息提示框
  		function createErrorInfoDialog(msg) {
  			var strHtml = '<div class="dialog-container">';
  			strHtml += '<div class="dialog-window">';
  			strHtml += '<div class="dialog-content" style="color:red">'+msg+'</div>';
  			strHtml += '<div class="dialog-footer">';
  			strHtml += '</div>';
  			strHtml += '</div>';
  			strHtml += '</div>';
  			$('body').append(strHtml);
  			// 并在5秒后消失
  			setTimeout(function() {
  				$('.dialog-container').remove();
  			}, 1000);
  		}
  		
  		
  </script>
</head>
<!-- Head END -->


<!-- Body BEGIN -->
<body>
	<div class="x-header x-header-gray border-1px-bottom">
		<div class="x-header-btn"></div>
		<div class="x-header-title">
			<fmt:message key="PAYMENT_TITLE"/>
		</div>
		<div class="x-header-btn">
		</div>
	</div>
	<div class="banklogodiv">
	 	<img alt="logo" src="${ctx}/images/banklogo.png">
	 </div>
	<div class="logincontain" style="margin-bottom: 5rem;">
		<div class="input_username" style="text-align: center">
			<span class="payment_dingdan"><fmt:message key="COMMON_30MIN_PAY" /></span>
			<span class="payment_cuntdown" data-seconds-left="${leftTime}">
					
			</span>
			</br>
			
			<span id="dingdanhao" class="payment_dingdan"><fmt:message key="PAYMENT_ORDER" /></span>
			<span id="amount" class="payment_amount"><fmt:message key="COMMON_DOLLAR" /></span>
		</div>
        <div class="input_username">
        	<input class="txt-input" type="text" autocomplete="off" placeholder="Card Holder">
        </div>
        <div class="input-password">
            <input class="txt-input" type="text" autocomplete="off" placeholder="Card Number" id="vpc_CardNum" onchange="checkShowBtn()">
        </div>
        <div class="input-password">
            <input class="txt-input" type="text" autocomplete="off" maxlength="5" placeholder="Card Expiry Date (MM/YY)" id="vpc_CardExp" onchange="checkShowBtn()" onblur="blurCardExp()">
        </div>
        <div class="input-password">
            <input class="txt-input" type="text" autocomplete="off" placeholder="Card Security Code (CSC)" id="vpc_CardSecurityCode" onchange="checkShowBtn()">
        </div>
        
        <div class="errormsg">
			<span id="errormsg"></span>
		</div>
        
        
        <div class="loginBtn">
            <a href="#" onclick="toPay()" id="payBtn"><fmt:message key="PAYMENT_BTN" /></a>
        </div>
        
        <div class="payment_power">
        	<fmt:message key="PAYMENT_POWER_BY" />
        </div>
        
        <input type="hidden" value="${orderNo }" id="orderNo"/>
	</div>
	
	<script type="text/javascript">
		$("#dingdanhao").append("${orderNo }");
		$("#amount").append(fmoney("${amount }", 2));
		
		$('.payment_cuntdown').startOtherTimer({
    		
    	});
	</script>
</body>
<!-- END BODY -->
</html>
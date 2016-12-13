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
<title><fmt:message key="ORDERLIST_TITLE" /></title>
<link rel="stylesheet" type="text/css" href="${ctx}/css/blue.css">
<script type="text/javascript" src="${ctx}/js/icheck.js"></script>
<script type="text/javascript">
	var goodsall = '<fmt:message key="ORDERLIST_GOODSALL" />';
	$(function(){
		$(".ico-back").click(function(){
			location.href="${ctx}/user/init"
		});
		initList('${tab}');
		
		kTouch('ordersList', 'y');
		
	});
	function toDetail(id){
		location.href="${ctx}/powderOrder/"+id+"?tab="+selectTab;
	}
	
	function toShowPay(orderId,payMethod) {
		if (payMethod == null || payMethod == "" || payMethod == "null") {
			// 跳转支付画面
			$("#gotoPurchaseBtn").attr('onclick',"gotoPurchase('"+orderId+"')");
			$("#purchase-credit-pop-up").modal('show');
		} else {
			if (payMethod == '1') {
				// commonwealth支付画面
				location.href="/OZTT_Phone/powderOrder/toCWLPay?orderId="+orderId;
			} else if (payMethod == '4'){
				// 微信支付
				$("#purchase-credit-pop-up").modal('hide');
				createInfoDialog('微信支付开发中......','1');
			}
		}
	}
	
	var pageNo = 1;
	function initList(idd) {
		$.ajax({
			type : "GET",
			contentType:'application/json',
			url : '${pageContext.request.contextPath}/powderOrder/initList?orderStatus='+idd+'&pageNo='+pageNo,
			dataType : "json",
			data : "", 
			success : function(data) {
				if(!data.isException) {
					if (!data.isException) {
						
						var temp1 = '<div class="order-goods-div margin-1rem-top">';
						var temp2 = '	<div class="order-head">';
						var temp3 = '		<div class="order-time">{0}</div>';
						var temp4 = '	</div>';
						
						var temp5 = '	<div class="order-checkBlockBody powderorder-overflow">';
						var temp6 = '		<div class="order-groupinfo powderorder-box" style="width:{0}px">';
						var temp7 = '			<div class="powderorder-box-slide" style="width:100px" onclick="toDetail(\'{0}\')">';
						var temp8 = '				<span class="receivename">{0}</span>';
						var temp8_1 = '				<span class="elecExpressNo">{0}</span>';
						var temp9 = '				<span class="powderInfo">{0}</span>';
						var temp10 = '			</div>';
						var temp11 = '		</div>';
						var temp12 = '	</div>';
						
						var temp13 = '	<div class="order-bottom">';
						var temp14 = '		<div class="order-bottom-content">';
						var temp15 = '			<div class="powderorder-all-amount">';
						var temp16 = '				<span><fmt:message key="POWDER_ORDER_TOTAL_AMOUNT" />{0}</span>';
						var temp17 = '			</div>';
						var temp18 = '		</div>';
						var temp19 = '		<div class="order-canpay clearfix"><a onclick="toShowPay(\'{0}\',\'{1}\')"><fmt:message key="ORDERLIST_TOPAY" /></a></div>';
						var temp20 = '	</div>';
						var temp21 = '</div>';
					
						// 组装页面
						var dataHtml = "";
						if (data.orderList.length>0){
							
							for(var i=0;i<data.orderList.length;i++){
								var order = data.orderList[i];
								dataHtml += temp1;
								dataHtml += temp2;
								dataHtml += temp3.replace("{0}",order.orderDate);
								dataHtml += temp4;
								dataHtml += temp5;
								dataHtml += temp6.replace("{0}",110 * order.boxList.length + 25);
								
								var boxDetails = order.boxList;
								for (var j=0;j<boxDetails.length;j++){
									var boxDetail = boxDetails[j];
									dataHtml += temp7.replace("{0}",boxDetail.boxId);
									dataHtml += temp8_1.replace("{0}",boxDetail.elecExpressNo);
									dataHtml += temp8.replace("{0}",boxDetail.receiveName);
									
									var detailPowders = boxDetail.powderMikeList;
									for (var k=0;k<detailPowders.length;k++){
										var detailPowder = detailPowders[k];
										dataHtml += temp9.replace("{0}",detailPowder.powderBrand + "&nbsp;" + detailPowder.powderSpec + "&nbsp;" + "X" + detailPowder.number);
									}

									dataHtml += temp10;
								}
								
								dataHtml += temp11;
								dataHtml += temp12;
								dataHtml += temp13;
								dataHtml += temp14;
								dataHtml += temp15;
								dataHtml += temp16.replace("{0}",fmoney(order.totalAmount, 2));
								dataHtml += temp17;
								dataHtml += temp18;
								
								if (order.status == '0') {
									dataHtml += temp19.replace("{0}",order.orderNo).replace("{1}",order.paymentMethod);
								}
								dataHtml += temp20;
								dataHtml += temp21;
								
							}
							$("#ordersList").append(dataHtml);
						} else {
							if (pageNo > 1) {
								//$("#noMoreRecordDiv").css("display","");
							}
							closeLoadingDiv();
						}

					} else {
						
					}
				}
			},
			error : function(data) {
				
			}
		});
	}
	
	function kTouch(contentId,way){
	    var _start = 0,
	        _end = 0,
	        _content = document.getElementById(contentId);
	    function touchStart(event){
	        var touch = event.targetTouches[0];
	        _start = touch.pageY;
	    }
	    function touchMove(event){
	        var touch = event.targetTouches[0];
	        _end = _start - touch.pageY;
	    }
	    function touchEnd(event){
	    	if (($("#main_goods").height() - 200) <= $(window).scrollTop() + $(window).height() && _end > 0) {
	    		//$("#loadingDiv").css("display","");
	    		setTimeout(function(){
	    			pageNo += 1;
	    			initList();
	    			//closeLoadingDiv();
	    			/* setTimeout(function(){
	    				closeNoMoreDiv();
	    			},1000); */
	            },1000);
	    	}
	    	
	    }
	    _content.addEventListener('touchend',touchEnd,false);
	    _content.addEventListener('touchstart',touchStart,false);
	    _content.addEventListener('touchmove',touchMove,false);
	}
	
	function closeLoadingDiv(){
		$("#loadingDiv").css("display","none");
	}
	function closeNoMoreDiv(){
  		$("#noMoreRecordDiv").css("display","none");
  	}
	
	var selectTab = '${tab}';
	function reloadtab(tab){
		$("#ordersList").text('');
		pageNo = 0;
		selectTab = tab;
		initList(tab);
	}
	
	function gotoPurchase(orderId) {
		if (orderId == null || orderId == "") {
			return;
		}
		if ($("#radio-bank").attr("checked") == "checked") {
			// commonwealth支付画面
			location.href="${ctx}/powderOrder/toCWLPay?orderId="+orderId;
		} else {
			// 微信支付
			$("#purchase-credit-pop-up").modal('hide');
			createInfoDialog('微信支付开发中......','1');
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
			// 并在5秒后消失
			setTimeout(function() {
				$('.dialog-container').remove();
			}, 1000);
		}
	}
</script>
<style>
	.list_table{
		width: 100%;
	}
	
	.list_table tr td{
		
		font-size: 12px;
	}
	.list_table tr td p {
		padding: 2px 3px;
		margin: 0px;
	}
	
</style>
</head>
<!-- Head END -->

<!-- Body BEGIN -->
<body>
	<div class="x-header x-header-gray border-1px-bottom">
		<div class="x-header-btn ico-back"></div>
		<div class="x-header-title">
			<span><fmt:message key="ORDERLIST_TITLE" /></span>
		</div>
		<div class="x-header-btn"></div>
	</div>
	<div class="orderList-search-horizon">
		<ul class="nav nav-tabs">
			<li <c:if test="${tab == '0'}">class="active"</c:if>><a onclick="reloadtab('0');return false;" data-toggle="tab"><fmt:message key="ORDERLIST_WAITPAY" /></a></li>
			<li <c:if test="${tab == '1'}">class="active"</c:if>><a onclick="reloadtab('1');return false;" data-toggle="tab"><fmt:message key="ORDERLIST_INCONTROLLER" /></a></li>
			<li <c:if test="${tab == '3'}">class="active"</c:if>><a onclick="reloadtab('3');return false;" data-toggle="tab"><fmt:message key="ORDERLIST_COMPLATE" /></a></li>
		</ul>
	</div>
	<div id="ordersList" class="bottom_margin">
		
	</div>
	<div style="text-align: center;height:4rem;display:none" id="loadingDiv">
    	<span style="display:inline-block;width: 100%;" id="hasMore"><fmt:message key="COMMON_PUSH" /></br><fmt:message key="COMMON_HASMORE" /></span>
		<img src="${ctx}/images/loading.gif">
	</div>
	
	<div id="purchase-credit-pop-up" class="modal fade" role="dialog" aria-hidden="true" >
    	<div class="modal-dialog item-dialog">
	      <div class="modal-content">
	         
	         <div class="modal-body">
	         	<div class="powder_purchase_select">
					<ul>
			            <li>
			              <input type="radio" id="radio-bank" name="purchase-radio">
			              <label for="radio-bank"><fmt:message key="POWDER_PURCHASE_COMMON_WEALTH" /></label>
			            </li>
			            <li>
			              <input type="radio" id="radio-wechat" name="purchase-radio" checked>
			              <label for="radio-wechat"><fmt:message key="POWDER_PURCHASE_WECHAT" /></label>
			            </li>
			          </ul>
	           	</div>
	           	<div class="powder_purchase_confirm">
		            <a id="gotoPurchaseBtn" onclick="gotoPurchase('')"><fmt:message key="COMMON_CONFIRM_PAY"/></a>
	           	</div>
	           	<script>
					$(document).ready(function(){
						$('.powder_purchase_select input[type="radio"]').css('display','');
					  	$('.powder_purchase_select input[type="radio"]').iCheck({
			              checkboxClass: 'icheckbox_square-blue',
			              radioClass: 'iradio_square-blue',
			              increaseArea: '20%'
			            });
					});
					</script>
	           	
	         </div>
	      </div>
    	</div>
    </div>
</body>
<!-- END BODY -->
</html>
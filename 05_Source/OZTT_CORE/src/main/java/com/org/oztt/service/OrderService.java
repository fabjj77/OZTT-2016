package com.org.oztt.service;

import com.org.oztt.base.page.Pagination;
import com.org.oztt.base.page.PagingResult;
import com.org.oztt.entity.TConsOrder;
import com.org.oztt.formDto.OrderInfoDto;


public interface OrderService {

    /**
     * 插入订单信息
     * @throws Exception
     */
    public String insertOrderInfo(String customerNo, String payMethod, String hidDeliMethod, String hidAddressId) throws Exception;
    
    /**
     * 获取当前用户所有的订单信息
     * @return
     * @throws Exception
     */
    public PagingResult<OrderInfoDto> getAllOrderInfoForPage(Pagination pagination) throws Exception;
    
    /**
     * 删除订单信息
     * @param id
     * @throws Exception
     */
    public void deleteOrderById(String id, String customerNo) throws Exception;
    
    /**
     * 更新订单信息
     * @param tConsOrder
     * @throws Exception
     */
    public void updateOrderInfo(TConsOrder tConsOrder) throws Exception;
    
    /**
     * 取得当前的某个订单
     * @param orderId
     * @return
     * @throws Exception
     */
    public TConsOrder selectByOrderId(String orderId) throws Exception;
}

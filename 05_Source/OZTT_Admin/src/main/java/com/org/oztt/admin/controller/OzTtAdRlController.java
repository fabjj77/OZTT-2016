package com.org.oztt.admin.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.org.oztt.base.page.Pagination;
import com.org.oztt.base.page.PagingResult;
import com.org.oztt.contants.CommonConstants;
import com.org.oztt.entity.TCustomerMemberInfo;
import com.org.oztt.formDto.OzTtAdRlListDto;
import com.org.oztt.service.CommonService;
import com.org.oztt.service.CustomerService;

/**
 * 注册用户一览画面
 * 
 * @author linliuan
 */
@Controller
@RequestMapping("/OZ_TT_AD_RL")
public class OzTtAdRlController extends BaseController {

    @Resource
    private CustomerService customerService;

    @Resource
    private CommonService   commonService;

    /**
     * 注册用户检索画面
     * 
     * @param request
     * @param session
     * @return
     */
    @RequestMapping(value = "/search")
    public String init(Model model, HttpServletRequest request, HttpSession session, String pageNo) {
        try {
            if (StringUtils.isEmpty(pageNo)) {
                pageNo = "1";
            }
            Pagination pagination = new Pagination(Integer.valueOf(pageNo));
            PagingResult<OzTtAdRlListDto> pageInfo = customerService.getAllCustomerInfoForAdmin(pagination);
            model.addAttribute("customerLevel", commonService.getCustomerLevel());
            model.addAttribute("pageInfo", pageInfo);
            return "OZ_TT_AD_RL";
        }
        catch (Exception e) {
            logger.error(e.getMessage());
            return CommonConstants.ERROR_PAGE;
        }
    }

    /**
     * 得到用户的积分和级别
     * 
     * @param request
     * @param session
     * @return
     */
    @RequestMapping(value = "/getCustomerPointsAndLevel")
    public Map<String, Object> getCustomerPointsAndLevel(HttpServletRequest request, HttpSession session,
            @RequestParam String customerNo) {
        Map<String, Object> mapReturn = new HashMap<String, Object>();
        try {

            TCustomerMemberInfo tCustomerMemberInfo = customerService.getCustomerMemberInfo(customerNo);

            // 后台维护的时候提示让以逗号隔开
            mapReturn.put("tCustomerMemberInfo", tCustomerMemberInfo == null ? new TCustomerMemberInfo()
                    : tCustomerMemberInfo);
            mapReturn.put("isException", false);
            return mapReturn;
        }
        catch (Exception e) {
            logger.error(e.getMessage());
            mapReturn.put("isException", true);
            return null;
        }
    }
}

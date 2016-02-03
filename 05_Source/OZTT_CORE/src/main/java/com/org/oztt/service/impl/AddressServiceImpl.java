package com.org.oztt.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.org.oztt.dao.TAddressInfoDao;
import com.org.oztt.entity.TAddressInfo;
import com.org.oztt.service.AddressService;
import com.org.oztt.service.BaseService;

@Service
public class AddressServiceImpl extends BaseService implements AddressService {

    @Resource
    private TAddressInfoDao tAddressInfoDao;
    
    @Override
    public List<TAddressInfo> getAllAddress(String customerno, String deliveryMethod) throws Exception {
        return tAddressInfoDao.getAllAddress(customerno, deliveryMethod);
    }

    @Override
    public TAddressInfo getAddressById(Long id) throws Exception {
        return tAddressInfoDao.selectByPrimaryKey(id);
    }

    @Override
    public void updateAddress(TAddressInfo record) throws Exception {
        tAddressInfoDao.updateByPrimaryKeySelective(record);
    }

    @Override
    public void insertAddress(TAddressInfo record) throws Exception {
        tAddressInfoDao.insertSelective(record);
    }

    @Override
    public void deleteAddress(Long id) throws Exception {
        tAddressInfoDao.deleteByPrimaryKey(id);
        
    }

}
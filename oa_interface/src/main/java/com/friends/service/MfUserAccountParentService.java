package com.friends.service;

import java.util.List;

import org.springframework.data.domain.PageRequest;

import com.friends.entity.MfUserAccountParent;

import com.friends.entity.vo.MfUserAccountParentVo;
import com.friends.utils.Result;

public interface MfUserAccountParentService  {
	//这个是别类的接口
	public Result queryDynamic(MfUserAccountParentVo mfUserAccountParentVo);
	
	public MfUserAccountParent add(MfUserAccountParent t);//MfActivityReview
	public void delete(MfUserAccountParent id);
	public MfUserAccountParent update(MfUserAccountParent t);
	public MfUserAccountParent queryById(String id);
	public List<MfUserAccountParent> queryByExample(MfUserAccountParent t);
	public List<MfUserAccountParent> queryByExamplePageable(MfUserAccountParent t,PageRequest pageRequest);
	public void batchAdd(List<MfUserAccountParent> ts);
	public void batchDelete(List<MfUserAccountParent> ts);
	
}
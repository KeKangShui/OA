package com.friends.service.impl;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.friends.dao.MfUserAccountParentDao;
import com.friends.entity.MfUserAccountParent;
import com.friends.entity.MfUserTipoff;
import com.friends.entity.vo.MfUserAccountParentVo;
import com.friends.service.MfUserAccountParentService;
import com.friends.utils.Result;

@Service
public class MfUserAccountParentServiceImpl extends BaseService<MfUserAccountParentDao, MfUserAccountParent>
		implements MfUserAccountParentService {

	@Autowired
	MfUserAccountParentDao mfUserAccountParentDao;
	//在 JPA 规范中, EntityManager 是完成持久化操作的核心对象。
	@Autowired
	EntityManager em;

	@Override
	public Result queryDynamic(MfUserAccountParentVo mfUserAccountParentVo) {
		//分页
		int page = mfUserAccountParentVo.getPage();
		int pageSize = mfUserAccountParentVo.getPageSize();
		MfUserAccountParent mfActivityReview = mfUserAccountParentVo.getT();

		// 多表sqlCommonBody查询 返回单表数据
		StringBuilder sqlCommonBody = new StringBuilder();
		sqlCommonBody.append(" from mf_user_account_parent t where 1=1 ");

		// 遍历每个字段 发现约束类型不为NO的，则根据情况进行约束
		// 如果判空也得分类型：字符串与非字符串
		// 时间要模糊约束怎么办

		String sqlDataQuery = " select distinct t.* " + sqlCommonBody.toString() + " limit :from, :to ";
		String sqlCountQuery = " select count(1) " + sqlCommonBody.toString();
		Query dataQuery = em.createNativeQuery(sqlDataQuery, MfUserAccountParent.class);
		Query countQuery = em.createNativeQuery(sqlCountQuery);
		// 参数注入
		dataQuery.setParameter("from", (page * pageSize));
		dataQuery.setParameter("to", pageSize);

		// 多表需要使用object[][]来接收 并通过BeanHelper工具将其转换为与sql中结果集字段对应的bean
		List<MfUserAccountParent> list = dataQuery.getResultList();
		// BeanHelper.objectsListToEntity(List<Object[]> objectsList, Class<T>
		// c)
		int total = Integer.valueOf(countQuery.getSingleResult().toString());
		return new Result(list, total);
	}
	


	@Override
	public void delete(MfUserAccountParent T) {
		// TODO Auto-generated method stub
		mfUserAccountParentDao.delete(T);
		
	}

}

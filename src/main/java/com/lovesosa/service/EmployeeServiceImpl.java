package com.lovesosa.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lovesosa.bean.Employee;
import com.lovesosa.bean.EmployeeExample;
import com.lovesosa.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author lovesosa
 */
@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;


    @Override
    public List<Employee> getAll() {
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
        return employees;
    }

    @Override
    public int saveEmp(Employee employee) {
        return employeeMapper.insertSelective(employee);
    }

    @Override
    public long getEmpbyName(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        employeeExample.createCriteria().andEmpNameEqualTo(empName);
        return employeeMapper.countByExample(employeeExample);
    }

    @Override
    public Employee getEmpById(Integer empid) {
        return employeeMapper.selectByPrimaryKey(empid);
    }

    @Override
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    @Override
    public void deleteById(Integer empId) {
        employeeMapper.deleteByPrimaryKey(empId);
    }

    @Override
    public void deleteBatch(List<Integer> list) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(list);
        employeeMapper.deleteByExample(example);
    }
}

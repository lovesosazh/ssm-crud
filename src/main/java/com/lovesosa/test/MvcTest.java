package com.lovesosa.test;

import com.github.pagehelper.PageInfo;
import com.lovesosa.bean.Employee;
import com.lovesosa.controller.EmployeeController;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * @author lovesosa
 */
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:springmvc-config.xml"})
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
public class MvcTest {

    @Autowired
    WebApplicationContext context;

    MockMvc mockMvc;

    @Before
    public void init() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Autowired
    EmployeeController employeeController;

    @Test
    public void testPage() throws Exception {
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pageNo", "4")).andReturn();
        MockHttpServletRequest request = result.getRequest();
        PageInfo<Employee> pageInfo = (PageInfo<Employee>) request.getAttribute("pageInfo");
        System.out.println("当前页码: " + pageInfo.getPageNum());
        System.out.println("总页码: " + pageInfo.getPages());
        System.out.println("总记录数: " + pageInfo.getTotal());
        System.out.println("连续显示页数: ");
        int[] nums = pageInfo.getNavigatepageNums();
        for (int num : nums) {
            System.out.print(num + "\t");
        }
        System.out.println("数据: ");
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list) {
            System.out.println(employee);
        }
    }
}

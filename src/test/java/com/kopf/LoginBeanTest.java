package com.kopf;

import junit.framework.TestCase;

/**
 * Created by Dad on 2/14/2017.
 */
public class LoginBeanTest extends TestCase {

    public void testPasswordValidation() {
       LoginBean myTestValidate = new LoginBean();
       myTestValidate.setPassword("admin");
       assertEquals("admin password will return true", true, myTestValidate.validate());
       myTestValidate.setPassword("dfasdf");
       assertEquals("junk password will return false", false, myTestValidate.validate());
    }
}

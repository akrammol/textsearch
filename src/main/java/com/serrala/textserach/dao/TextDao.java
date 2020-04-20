package com.serrala.textserach.dao;

import com.serrala.textserach.util.HibernateUtil;
import com.serrala.textserach.util.TextUtil;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Session;

import java.sql.Clob;
import java.util.ArrayList;
import java.util.List;


public class TextDao {

    public List<String> getSerralaSearchFunc(String tableName, String searchterm, String columnName, int limitText) {
        List<String> strings = new ArrayList<>();
        String term = searchterm;
        if (StringUtils.isNoneEmpty(columnName))
            term = searchterm + " within " + columnName;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Clob> clobs = session.createNativeQuery(
                    "SELECT FUNC_SEARCH(:tbl,:term) FROM DUAL")
                    .setParameter("tbl", tableName)
                    .setParameter("term", term)
                    .getResultList();
            for (Clob clob : clobs) {
                String str = TextUtil.clobToString(clob);
                str = TextUtil.getLimitTextByIndex(searchterm, columnName, limitText, str);
                strings.add(str);
            }
            return strings;
        } catch (Exception e) {
            System.out.println("# some problem!!!");
            return null;
        }
    }
}

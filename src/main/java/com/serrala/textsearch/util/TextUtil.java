package com.serrala.textsearch.util;

import org.apache.commons.lang3.StringUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.Clob;
import java.sql.SQLException;

public class TextUtil {

    public static String clobToString(Clob data) {
        StringBuilder sb = new StringBuilder();
        try {
            Reader reader = data.getCharacterStream();
            BufferedReader br = new BufferedReader(reader);
            String line;
            while (null != (line = br.readLine())) {
                sb.append(line);
            }
            br.close();
        } catch (SQLException e) {
            e.getMessage();
        } catch (IOException e) {
            e.getMessage();
        }
        return sb.toString();
    }

    public static String getLimitTextByIndex(String searchterm, String columnName, int limitText, String str) {
        str = StringUtils.substringBetween(str, "<" + columnName + ">", "</" + columnName + ">");
        int beforeIndex = str.indexOf(searchterm) - limitText;
        int afterIndex = str.indexOf(searchterm)+searchterm.length() + limitText;
        if (beforeIndex <=0)
            beforeIndex = 0;
        str = StringUtils.substring(str, beforeIndex, afterIndex);
        return str;
    }
}

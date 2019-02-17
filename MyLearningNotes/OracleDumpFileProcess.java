package com.rskytech.dataMove.action;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class OracleDumpFileProcess {
    public static void main(String[] args) {
        try {
            exportDumpFile();
        } catch (Exception e) {
            System.out.println("导出DUMP文件时出错了哦!!!");
            e.printStackTrace();
        }
    }

    /**
     * 读取属性文件相关配置导出数据
     *
     * @throws Exception
     */
    public static void exportDumpFile() throws Exception {
        Properties properties = new Properties();
        InputStream inStream = OracleDumpFileProcess.class.getResourceAsStream("expOrImpDumpFile.properties");
        properties.load(inStream);//加载资源文件
        String jdbc_username = properties.getProperty("jdbc_username");
        String jdbc_password = properties.getProperty("jdbc_password");
        String exp_saveFilePath = properties.getProperty("exp_saveFilePath");
        String oracle_sid = properties.getProperty("oracle_sid");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String f = sdf.format(new Date());
        String fileName = exp_saveFilePath + "/" + f + ".dmp";
        String exportDumpSyntax = "exp " + jdbc_username + "/" + jdbc_password + "@" + oracle_sid + " file=" + fileName;

        //文件存放目录不存在则创建
        File saveFile = new File(exp_saveFilePath);
        if (!saveFile.exists()) {// 如果目录不存在
            saveFile.mkdirs();// 创建文件夹
        }
        boolean finalResult = exportDatabaseTool(exportDumpSyntax);
        System.out.println("最终结果：" + finalResult);
    }


    /**
     * 调用cmd进程的方法
     * @param expOrImpSyntax  导出或导入语法
     * @return
     * @throws InterruptedException
     */
    public static boolean exportDatabaseTool(String expOrImpSyntax) throws InterruptedException {
        try {
            final Process process = Runtime.getRuntime().exec(expOrImpSyntax);
            //处理InputStream的线程
            new Thread() {
                @Override
                public void run() {
                    BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
                    processReadLine(in);
                }
            }.start();
            //处理ErrorStream的线程
            new Thread() {
                @Override
                public void run() {
                    BufferedReader err = new BufferedReader(new InputStreamReader(process.getErrorStream()));
                    processReadLine(err);
                }
            }.start();
            if (process.waitFor() == 0) {
                return true;
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }


    /**
     * 读取每一行的信息,输出到控制台中
     * @param bufferedReader
     */
    private static void processReadLine(BufferedReader bufferedReader) {
        String line;
        try {
            while ((line = bufferedReader.readLine()) != null) {
                System.out.println("output: " + line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                bufferedReader.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

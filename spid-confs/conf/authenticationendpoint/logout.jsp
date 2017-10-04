<%--
  ~ Copyright (c) 2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%@page import="org.wso2.carbon.identity.application.authentication.endpoint.util.Constants" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Arrays" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.TenantDataManager" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="org.wso2.carbon.identity.core.util.IdentityCoreConstants" %>

<%!
    private static final String FIDO_AUTHENTICATOR = "FIDOAuthenticator";
    private static final String IWA_AUTHENTICATOR = "IWAAuthenticator";
    private static final String IS_SAAS_APP = "isSaaSApp";
    private static final String BASIC_AUTHENTICATOR = "BasicAuthenticator";
    private static final String OPEN_ID_AUTHENTICATOR = "OpenIDAuthenticator";
%><fmt:bundle basename="org.wso2.carbon.identity.application.authentication.endpoint.i18n.Resources">

    <%
        String BUNDLE = "org.wso2.carbon.identity.application.authentication.endpoint.i18n.Resources";
        ResourceBundle resourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale());

        request.getSession().invalidate();
        String queryString = request.getQueryString();
        Map<String, String> idpAuthenticatorMapping = null;
        if (request.getAttribute(Constants.IDP_AUTHENTICATOR_MAP) != null) {
            idpAuthenticatorMapping = (Map<String, String>) request.getAttribute(Constants.IDP_AUTHENTICATOR_MAP);
        }

        String errorMessage = "Authentication Failed! Please Retry";
        String errorCode = "";
        if(request.getParameter(Constants.ERROR_CODE)!=null){
            errorCode = request.getParameter(Constants.ERROR_CODE) ;
        }
        String loginFailed = "false";

        if (Boolean.parseBoolean(request.getParameter(Constants.AUTH_FAILURE))) {
            loginFailed = "true";
            if (request.getParameter(Constants.AUTH_FAILURE_MSG) != null) {
                errorMessage = resourceBundle.getString(request.getParameter(Constants.AUTH_FAILURE_MSG));
            }
        }
    %>
    <%

        boolean hasLocalLoginOptions = false;
        List<String> localAuthenticatorNames = new ArrayList<String>();

        if (idpAuthenticatorMapping != null && idpAuthenticatorMapping.get(Constants.RESIDENT_IDP_RESERVED_NAME) != null) {
            String authList = idpAuthenticatorMapping.get(Constants.RESIDENT_IDP_RESERVED_NAME);
            if (authList != null) {
                localAuthenticatorNames = Arrays.asList(authList.split(","));
            }
        }


    %>
    <%
        boolean reCaptchaEnabled = false;
        if (request.getParameter("reCaptcha") != null && "TRUE".equalsIgnoreCase(request.getParameter("reCaptcha"))) {
            reCaptchaEnabled = true;
        }
    %>
    <!DOCTYPE HTML>
<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="it"><![endif]-->
<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8" lang="it"><![endif]-->
<!--[if IE 8]><html class="no-js lt-ie9" lang="it"><![endif]-->
<!--[if gt IE 8]><!--><html class="no-js" lang="it"><!--<![endif]-->
		<head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SPID Identity Server</title>
		
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="apple-touch-icon" sizes="57x57" href="img/favicon/apple-touch-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="img/favicon/apple-touch-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="img/favicon/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="img/favicon/apple-touch-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="img/favicon/apple-touch-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="img/favicon/apple-touch-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="img/favicon/apple-touch-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="img/favicon/apple-touch-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-touch-icon-180x180.png">
    <link rel="icon" type="image/png" href="img/favicon/favicon-32x32.png" sizes="32x32">
    <link rel="icon" type="image/png" href="img/favicon/android-chrome-192x192.png" sizes="192x192">
    <link rel="manifest" href="img/favicon/manifest.json">
    <link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg">
    <meta name="msapplication-TileColor" content="#FFFFFF">
    <meta name="msapplication-TileImage" content="img/favicon/mstile-144x144.png">
    <meta name="theme-color" content="#ffffff">
    
        <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/Roboto.css" rel="stylesheet">
        <link href="css/custom-common.css" rel="stylesheet">
		
		<link rel="stylesheet" type="text/css" href="css/main.min.css" />

        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/selectivizr.min.js"></script>
		<script src="js/respond.min.js"></script>
		<script src="js/rem.min.js"></script>
        <![endif]-->

        <%
            if (reCaptchaEnabled) {
        %>
        <script src='<%=
        (request.getParameter("reCaptchaAPI"))%>'></script>
        <%
            }
        %>
    </head>

    <body> 
    <div id="outer">
	     <div id="contain-all">
            <div class="inner">
                <div class="grid spacer-top-1">
                    <div class="width-one-whole spid-logo"><img src="img/spid-level1-logo-bb.svg" onerror="this.src='img/spid-level1-logo-bb.png'; this.onerror=null;" alt="SPID 1" /></div>
                </div>
                
                <div class="grid spacer-top-1">
                    <div class="width-one-whole"><span class="spid-hr"></span></div>
                </div>
                <!--  * begin * -->
                <div class="width-one-whole pa-title">Hai effettuato con successo il logout </div>
                <!--  * end * -->
            </div>
	     </div>
    </div>
    <div id="header">
        <div id="header-inner">
            <img id="idp-logo" src="img/idp-logo-demo.svg" onerror="this.src='img/idp-logo-demo.png'; this.onerror=null;" alt="IDP Demo" />
        </div>
    </div>
    <div id="footer">
	<div id="footer-inner">
            <a href="http://www.spid.gov.it/check" target="blank_"><img id="spid-agid-logo" src="img/spid-agid-logo-bb.svg" onerror="this.src='img/spid-agid-logo-bb.png'; this.onerror=null;" alt="SPID - AgID Agenzia per l'Italia Digitale - Check" /></a>
        </div>
    </div>    
    <script src="js/jquery.min.js"></script>
</body>
</html>


</fmt:bundle>


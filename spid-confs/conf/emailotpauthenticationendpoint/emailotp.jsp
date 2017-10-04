<!--
~  Copyright (c) 2016, WSO2 Inc. (http://wso2.com) All Rights Reserved.
~
~  WSO2 Inc. licenses this file to you under the Apache License,
~  Version 2.0 (the "License"); you may not use this file except
~  in compliance with the License.
~  You may obtain a copy of the License at
~
~   http://www.apache.org/licenses/LICENSE-2.0
~
~  Unless required by applicable law or agreed to in writing,
~  software distributed under the License is distributed on an
~  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~  KIND, either express or implied.  See the License for the
~  specific language governing permissions and limitations
~  under the License.
-->
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@page import="org.wso2.carbon.identity.application.authentication.endpoint.util.Constants" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.TenantDataManager" %>
<%
       request.getSession().invalidate();
       String queryString = request.getQueryString();
       Map<String, String> idpAuthenticatorMapping = null;
       if (request.getAttribute(Constants.IDP_AUTHENTICATOR_MAP) != null) {
           idpAuthenticatorMapping = (Map<String, String>) request.getAttribute(Constants.IDP_AUTHENTICATOR_MAP);
       }

       String errorMessage = "Authentication Failed! Please Retry";
       String authenticationFailed = "false";

       if (Boolean.parseBoolean(request.getParameter(Constants.AUTH_FAILURE))) {
           authenticationFailed = "true";

           if (request.getParameter(Constants.AUTH_FAILURE_MSG) != null) {
               errorMessage = request.getParameter(Constants.AUTH_FAILURE_MSG);

                if (errorMessage.equalsIgnoreCase("authentication.fail.message")) {
                   errorMessage = "Autenticazione fallita. Verifica di aver inserito correttamente il codice OTP";
               }
           }
       }
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="it"><![endif]-->
<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8" lang="it"><![endif]-->
<!--[if IE 8]><html class="no-js lt-ie9" lang="it"><![endif]-->
<!--[if gt IE 8]><!--><html class="no-js" lang="it"><!--<![endif]-->
    <head>
        <title>SPID Identity Server</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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

        <script src="js/scripts.js"></script>
        <script src="assets/js/jquery-1.7.1.min.js"></script>
        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/respond.min.js"></script>
        <script src="js/selectivizr.min.js"></script>
        <script src="js/rem.min.js"></script>
    <![endif]-->
    </head>
    <body>
        <!-- header -->
        <div id="outer">
            <div id="contain-all">
                <div class="inner">
                    <div class="grid spacer-top-1">
                        <div class="width-one-whole spid-logo"><img src="img/spid-level2-logo-bb.svg" onerror="this.src='img/spid-level2-logo-bb.png'; this.onerror=null;" alt="SPID 2" /></div>
                    </div>

                    <div class="clearfix"></div>
                    <div class="padding-double login-form">

                        <div class="grid spacer-top-1">
                            <div class="width-one-whole"><span class="spid-hr"></span></div>
                        </div>
                        <div class="grid spacer-top-1">
                            <div class="width-one-whole pa-message">Per accedere al servizio è richiesta l'inserimento del codice temporaneo (otp) ricevuto via email 

                                <% if (request.getParameter("screenValue") != null) { %>
                                all'indirizzo <%= request.getParameter("screenValue")%>
                                <% }  %>

                            </div>
                        </div>
                        <div class="grid spacer-top-1">
                            <div class="width-one-whole pa-title">
                                <% 
                                        String relyingParty = request.getParameter("relyingParty");
                                        out.println("Richiesta accesso da "+relyingParty);
                                %>						
                            </div>
                        </div>
                        <!-- SPID LOGIN FORM * begin * -->



                        <form id="codeForm" name="codeForm" action="../commonauth"  method="POST" class="grid">
                            <div id="contentTable" class="identity-box">
                                <%
                                    String loginFailed = request.getParameter("authFailure");
                                    if (loginFailed != null && "true".equals(loginFailed)) {
                                        String authFailureMsg = request.getParameter("authFailureMsg");
                                        if (authFailureMsg != null && "login.fail.message".equals(authFailureMsg)) {
                                %>
                                <div class="alert alert-error">Authentication Failed! Please Retry</div>
                                <% } }  %>
                                <div class="width-one-whole spacer-top-3">         
                                    <fieldset>
                                        <label for="password" class="float-left label-bold">Codice</label>

                                        <%
                                        if ("true".equals(authenticationFailed)) {
                                        %>
                                        <div id="resendCodeLinkDiv" class="forgot-link">
                                            <a id="resend">Non hai ricevuto il codice?
                                                <img class="open-link" src="img/open-link.svg" onerror="this.src='img/open-link.png'; this.onerror=null;" alt="Si apre una nuova pagina" /></a>
                                        </div>
                                        <% } %>



                                        <span class="forgot-link hidden">
                                            <a href="#">
                                                Non hai ricevuto il codice?
                                                <img class="open-link" src="img/open-link.svg" onerror="this.src='img/open-link.png'; this.onerror=null;" alt="Si apre una nuova pagina" />
                                            </a>
                                        </span>
                                        <!-- Token Pin -->
                                        <% if (request.getParameter("screenValue") != null) { %>
                                        <div class="control-group">
                                            <input type="password" id='OTPCode' name="OTPCode" class="input-xlarge" size='30'/>
                                            <% } else { %>
                                            <div class="control-group">
                                                <input type="password" id='OTPCode' name="OTPCode" class="input-xlarge" size='30'/>
                                                <% } %>
                                            </div>
                                            <input type="hidden" name="sessionDataKey"
                                                   value='<%=request.getParameter("sessionDataKey")%>'/><br/>
                                    </fieldset>

                                    <div id="errorDiv"></div>
                                    <%
                                        if ("true".equals(authenticationFailed)) {
                                    %>
                                    <div class="alert alert-danger" id="failed-msg">
                                        <%=errorMessage%>
                                    </div>
                                    <% } %>
                                    <div id="alertDiv"></div>

                                    <div> 
                                        <button type="button" name="authenticate" id="authenticate" value="Authenticate" class="italia-it-button italia-it-button-size-m button-spid spacer-top-3">
                                            <span class="italia-it-button-icon"><img src="img/spid-ico-circle-bb.svg" onerror="this.src='img/spid-ico-circle-bb.png'; this.onerror=null;" alt="" /></span>
                                            <span class="italia-it-button-text">Entra con SPID</span>
                                        </button>
                                    </div>

                                </div>
                            </div>
                    </div>
                    <input type='hidden' name='resendCode' id='resendCode' value='false'/>
                    </form>
                    <div class="clearfix"></div>





                </div>
            </div>
            <!-- /content -->
        </div>
    </div>
    <!-- /content/body -->
</div>
</div>
<div id="header">
    <div id="header-inner">
        <img id="agid-logo" src="img/agid.logo-dark.svg" onerror="this.src='img/idp-logo-demo.png'; this.onerror=null;" alt="AgID Logo" height="70" />
    </div>
</div>
<!-- footer -->
<div id="footer">
    <div id="footer-inner">
        <a href="http://www.spid.gov.it/check" target="blank_">
            <img id="spid-agid-logo" src="img/spid-agid-logo-bb.svg" onerror="this.src='img/spid-agid-logo-bb.png'; this.onerror=null;" alt="SPID - AgID Agenzia per l'Italia Digitale - Check" /></a>
    </div>
</div>  
<script src="libs/jquery_1.11.3/jquery-1.11.3.js"></script>
<script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('#authenticate').click(function () {
            var code = document.getElementById("OTPCode").value;
            if (code == "") {
                document.getElementById('alertDiv').innerHTML = '<div id="error-msg" class="alert alert-danger">Please enter the code!</div>';
            } else {
                $('#codeForm').submit();
            }
        });
    });
    $(document).ready(function () {
        $('#resendCodeLinkDiv').click(function () {
            document.getElementById("resendCode").value = "true";
            $('#codeForm').submit();
        });
    });
</script>
</body>
</html>

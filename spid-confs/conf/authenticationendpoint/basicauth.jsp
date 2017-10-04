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

<%@ page import="org.apache.cxf.jaxrs.client.JAXRSClientFactory" %>
<%@ page import="org.apache.cxf.jaxrs.provider.json.JSONProvider" %>
<%@ page import="org.apache.http.HttpStatus" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.client.SelfUserRegistrationResource" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.AuthenticationEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.core.util.IdentityUtil" %>
<%@ page import="javax.ws.rs.core.Response" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.ResendCodeRequestDTO" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.UserDTO" %>


<%
    String resendUsername = request.getParameter("resend_username");
    if (StringUtils.isNotBlank(resendUsername)) {

        String url = config.getServletContext().getInitParameter(Constants.ACCOUNT_RECOVERY_REST_ENDPOINT_URL);

        ResendCodeRequestDTO selfRegistrationRequest = new ResendCodeRequestDTO();
        UserDTO userDTO = AuthenticationEndpointUtil.getUser(resendUsername);
        selfRegistrationRequest.setUser(userDTO);
        url = url.replace("tenant-domain", userDTO.getTenantDomain());

        List<JSONProvider> providers = new ArrayList<JSONProvider>();
        JSONProvider jsonProvider = new JSONProvider();
        jsonProvider.setDropRootElement(true);
        jsonProvider.setIgnoreNamespaces(true);
        jsonProvider.setValidateOutput(true);
        jsonProvider.setSupportUnwrapped(true);
        providers.add(jsonProvider);

        SelfUserRegistrationResource selfUserRegistrationResource = JAXRSClientFactory
                .create(url, SelfUserRegistrationResource.class, providers);
        Response selfRegistrationResponse = selfUserRegistrationResource.regenerateCode(selfRegistrationRequest);
        if (selfRegistrationResponse != null &&  selfRegistrationResponse.getStatus() == HttpStatus.SC_CREATED) {
%>
<div class="alert alert-info"><%= Encode.forHtml(resourceBundle.getString(Constants.ACCOUNT_RESEND_SUCCESS_RESOURCE)) %>
</div>
<%
} else {
%>
<div class="alert alert-danger"><%= Encode.forHtml(resourceBundle.getString(Constants.ACCOUNT_RESEND_FAIL_RESOURCE))  %>
</div>
<%
        }
    }
%>


<%
    String type = request.getParameter("type");
    if ("samlsso".equals(type)) {
%>
<form action="/samlsso" method="post" id="loginForm" class="grid" name="spid-login">
    <input id="tocommonauth" name="tocommonauth" type="hidden" value="true">
    <%
        } else if ("oauth2".equals(type)){
    %>
    <form action="/oauth2/authorize" method="post" id="loginForm">
        <input id="tocommonauth" name="tocommonauth" type="hidden" value="true">

        <%
            } else {
        %>

        <form action="../commonauth" method="post" id="loginForm">

            <%
                }
            %>

            <% if (Boolean.parseBoolean(loginFailed)) { %>
            <div class="alert alert-danger" id="error-msg"><%= Encode.forHtml(errorMessage) %>
            </div>
            <%}else if((Boolean.TRUE.toString()).equals(request.getParameter("authz_failure"))){%>
            <div class="alert alert-danger" id="error-msg">You are not authorized to login
            </div>
            <%}%>

            <div class="width-one-whole">         
                <fieldset>
                    <div>
                        <label for="nome_utente" class="float-left label-bold">Nome utente</label>
                        <span class="forgot-link hidden">
                            <a href="#">
                                Nome utente dimenticato?
                                <img class="open-link" src="img/open-link.svg" onerror="this.src='img/open-link.png'; this.onerror=null;" alt="Si apre una nuova pagina" />
                            </a>
                        </span>
                        <input id="username" name="username" type="text" class="input-error" placeholder="Inserisci il Nome utente" ><span class="clear"></span>
                    </div>
                    <div>
                        <label for="password" class="float-left label-bold">Password</label>
                        <span class="forgot-link hidden">
                            <a href="#">
                                Password dimenticata?
                                <img class="open-link" src="img/open-link.svg" onerror="this.src='img/open-link.png'; this.onerror=null;" alt="Si apre una nuova pagina" />
                            </a>
                        </span>
                        <input id="password" name="password" type="password" class="showpassword"><span class="clear"></span>
                    </div>
                    <div class="push-right spacer-top-2">
                        <input id="showHide" type="checkbox" class="showpasswordcheckbox" /> 
                        <label class="showHideLabel" for="showHide">Mostra password</label></div>
                    <div>
                        <input type="hidden" name="sessionDataKey" value='<%=Encode.forHtmlAttribute(request.getParameter("sessionDataKey"))%>'/>
                    </div>
                </fieldset>
                <%
                    if (reCaptchaEnabled) {
                %>
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                    <div class="g-recaptcha"
                         data-sitekey="<%=Encode.forHtmlContent(request.getParameter("reCaptchaKey"))%>">
                    </div>
                </div>
                <%
                    }
                %>

                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                    <%

                        String scheme = request.getScheme();
                        String serverName = request.getServerName();
                        int serverPort = request.getServerPort();
                        String uri = (String) request.getAttribute("javax.servlet.forward.request_uri");
                        String prmstr = (String) request.getAttribute("javax.servlet.forward.query_string");
                        String urlWithoutEncoding = scheme + "://" +serverName + ":" + serverPort + uri + "?" + prmstr;
                        String urlEncodedURL = URLEncoder.encode(urlWithoutEncoding, "UTF-8");

                        if (request.getParameter("relyingParty").equals("wso2.my.dashboard")) {
                            String identityMgtEndpointContext =
                                    application.getInitParameter("IdentityManagementEndpointContextURL");
                            if (StringUtils.isBlank(identityMgtEndpointContext)) {
                                identityMgtEndpointContext = IdentityUtil.getServerURL("/accountrecoveryendpoint", true, true);
                            }

                            URL url = null;
                            HttpURLConnection httpURLConnection = null;

                            url = new URL(identityMgtEndpointContext + "/recoverpassword.do?callback="+Encode.forHtmlAttribute
                                    (urlEncodedURL ));
                            httpURLConnection = (HttpURLConnection) url.openConnection();
                            httpURLConnection.setRequestMethod("HEAD");
                            httpURLConnection.connect();
                            if (httpURLConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    %>
                    <a id="passwordRecoverLink" href="<%=url%>">Forgot Password </a>
                    <br/><br/>
                    <%
                        }

                        url = new URL(identityMgtEndpointContext + "/recoverusername.do?callback="+Encode.forHtmlAttribute
                                (urlEncodedURL ));
                        httpURLConnection = (HttpURLConnection) url.openConnection();
                        httpURLConnection.setRequestMethod("HEAD");
                        httpURLConnection.connect();
                        if (httpURLConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    %>
                    <a id="usernameRecoverLink" href="<%=url%>">Forgot Username </a>
                    <br/><br/>
                    <%
                        }




                        url = new URL(identityMgtEndpointContext + "/register.do?callback="+Encode.forHtmlAttribute
                                (urlEncodedURL ));
                        httpURLConnection = (HttpURLConnection) url.openConnection();
                        httpURLConnection.setRequestMethod("HEAD");
                        httpURLConnection.connect();
                        if (httpURLConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    %>
                    Don't have an account?
                    <a id="registerLink" href="<%=url%>">Register Now</a>
                    <%
                            }
                        }
                    %>
                    <br/>
                    <% if (Boolean.parseBoolean(loginFailed) && errorCode.equals(IdentityCoreConstants.USER_ACCOUNT_NOT_CONFIRMED_ERROR_CODE) && request.getParameter("resend_username") == null) { %>
                    Not received confirmation email ?
                    <a id="registerLink" href="login.do?resend_username=<%=Encode.forHtml(request.getParameter("failedUsername"))%>&<%=AuthenticationEndpointUtil.cleanErrorMessages(request.getQueryString())%>">Re-Send</a>

                    <%}%>
                </div>
                <button type="submit" class="italia-it-button italia-it-button-size-m button-spid spacer-top-1">
                    <span class="italia-it-button-icon"><img src="img/spid-ico-circle-bb.svg" onerror="this.src='img/spid-ico-circle-bb.png'; this.onerror=null;" alt="" /></span>
                    <span class="italia-it-button-text">Entra con SPID</span>
                </button>
            </div>
            <div class="clearfix"></div>
        </form>

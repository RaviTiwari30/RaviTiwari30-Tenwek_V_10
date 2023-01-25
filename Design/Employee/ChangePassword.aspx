<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Design_Employee_ChangePassword" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        function validate() {
            if ($('#ctl00_ContentPlaceHolder1_TextBox1_HelpLabel').text() != "")
            {
                $("#<%=lblMsg.ClientID%>").text('Please Enter The ' + $('#ctl00_ContentPlaceHolder1_TextBox1_HelpLabel').text());
                $("#<%=txtNewPassword.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtOldPassword.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Old Password');
                $("#<%=txtOldPassword.ClientID%>").focus();
                return false;
            }
          
            if ($.trim($("#<%=txtNewPassword.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter New Password');
                $("#<%=txtNewPassword.ClientID%>").focus();
                return false;
            }
            
            if ($("#<%=txtNewPassword.ClientID%>").val().length < 6) {
                $("#<%=lblMsg.ClientID%>").text('New Password can not be less than 12 characters');
                $("#<%=txtNewPassword.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtConfirmPassword.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Confirm Password');
                $("#<%=txtConfirmPassword.ClientID%>").focus();
                return false;
            }
            if ($("#<%=txtConfirmPassword.ClientID%>").val().length < 6) {
                $("#<%=lblMsg.ClientID%>").text('Confirm Password can not be less than 12 characters');
                $("#<%=txtNewPassword.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtNewPassword.ClientID%>").val()) != $.trim($("#<%=txtConfirmPassword.ClientID%>").val())) {
                $("#<%=lblMsg.ClientID%>").text('New Password does not match with the confirmed Password');
                $("#<%=txtConfirmPassword.ClientID%>").focus();
                return false;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager runat="Server" ID="ScriptManager1" EnableScriptGlobalization="true" EnableScriptLocalization="true" />
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Change Password<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
       
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Basic Information
            </div>
          <div class="row">
              <div class="col-md-1"></div>
              <div class="col-md-22">
                  <div class="row">
                  <div class="col-md-3">
                      <label class="pull-left">User Type</label>
                      <b class="pull-right">:</b>
                  </div>
                   <div class="col-md-5">
                       <asp:Label ID="lblUserType" runat="server" Text="User Type"></asp:Label>
                  </div>
                      <div class="col-md-3">
                      <label class="pull-left">User Name</label>
                      <b class="pull-right">:</b>
                  </div>
                   <div class="col-md-5">
                       <asp:TextBox ID="txtUserName" runat="server" CssClass="inputbox" TabIndex="1" ReadOnly="true" Enabled="false"></asp:TextBox>
                  </div>
                      <div class="col-md-3">
                      <label class="pull-left">Old Password</label>
                      <b class="pull-right">:</b>
                  </div>
                   <div class="col-md-5">
                         <asp:TextBox ID="txtOldPassword" runat="server" CssClass="inputbox requiredField" TabIndex="1" TextMode="Password"   data-title="Enter Old Password"></asp:TextBox>
                           <%-- <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                            <div style="display: none;">
                                <asp:TextBox ID="txtOldPassCheck" runat="server" CssClass="inputbox" TabIndex="2" TextMode="Password"
                                    Width="134px"></asp:TextBox></div>
                  </div>
                      </div>

                  <div class="row">
                  <div class="col-md-3">
                      <label class="pull-left">New Password</label>
                      <b class="pull-right">:</b>
                  </div>
                   <div class="col-md-5">
  <asp:TextBox ID="txtNewPassword" runat="server" CssClass="inputbox requiredField" TabIndex="2"
                                TextMode="Password" MaxLength="15" data-title="Enter New Password"></asp:TextBox>
                  </div>
                      <div class="col-md-8">
      
                      </div>
                      <div class="col-md-3">
                      <label class="pull-left">Confirm Password</label>
                      <b class="pull-right">:</b>
                  </div>
                   <div class="col-md-5">
                       <asp:TextBox ID="txtConfirmPassword" runat="server" TabIndex="3" CssClass="requiredField"
                                TextMode="Password" MaxLength="15"   data-title="Retype to Confirm Password"></asp:TextBox>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" Display="Dynamic"
                                ErrorMessage="Confirm Password Not Match With New Password" ControlToCompare="txtNewPassword" ForeColor="Red" Font-Bold="true" 
                                ControlToValidate="txtConfirmPassword"></asp:CompareValidator>
                  </div>
                     
                      </div>
                  <div class="row">
                       <div class="col-md-3">
                      <label class="pull-left"></label>
                      <b class="pull-right"></b>
                  </div>
                   <div class="col-md-21">
                        <asp:Label ID="TextBox1_HelpLabel" runat="server" Font-Bold="true" BackColor="Yellow" ForeColor="Red" />
                  </div>
                  </div>
              </div>
              <div class="col-md-1"></div>
          </div>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
           
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                    TabIndex="4" Text="Save" ToolTip="Click To Save" OnClientClick="return validate() " />
            <cc1:PasswordStrength ID="PasswordStrength1" runat="server" TargetControlID="txtNewPassword" ValidateRequestMode="Disabled" 
                DisplayPosition="RightSide"
                StrengthIndicatorType="Text"
                PreferredPasswordLength="6"
                PrefixText="Strength: "
                TextCssClass="TextIndicator_TextBox3"
                HelpStatusLabelID="TextBox1_HelpLabel"
                TextStrengthDescriptions="VeryPoor;Weak;Average;Strong;Excellent"
                TextStrengthDescriptionStyles="VeryPoor;Weak;Average;Excellent;Strong"
                MinimumLowerCaseCharacters="1"
                MinimumUpperCaseCharacters="1"
                MinimumSymbolCharacters="1"
                RequiresUpperAndLowerCaseCharacters="false"
                BarBorderCssClass="border" 
                />

        </div>
    </div>
      <style type="text/css">
      .VeryPoor
       {
         background-color:red;
       color:white;
       font-weight:bold;
         }

          .Weak
        {
         background-color:orange;
         color:white;
       font-weight:bold;
         }

          .Average
         {
          background-color: #A52A2A;
          color:white;
       font-weight:bold;
         }
          .Excellent
         {
         background-color:yellow;
         color:white;
       font-weight:bold;
         }
          .Strong
         {
         background-color:green;
         color:white;
       font-weight:bold;
         }
          .border
         {
          border: medium solid #800000;
          width:500px;                
         }
      </style>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Email_id.aspx.cs" Inherits="Design_Email_Email_id" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function Validate()
        {
            if ($.trim($('#txtFromEmail').val()).length == 0)
            {
                $('#lblMsg').text('Please Enter the Email id');
                $('#txtFromEmail').focus();
                return false;
            }
            var emailaddress = jQuery.trim(jQuery('#txtFromEmail').val());
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                jQuery('#lblMsg').text('Please Enter Valid Email Address');
                jQuery('#txtFromEmail').focus();
                return false;
            }
            if ($.trim($('#txtPassword').val()).length < 6) {
                $('#lblMsg').text('Please Enter the Password (minimum 6 digit)');
                $('#txtPassword').focus();
                return false;
            }
            if ($.trim($('#txtsmtphost').val()) == "") {
                $('#lblMsg').text('Please Enter the SMTP HOST.');
                $('#txtsmtphost').focus();
                return false;
            }
            if ($.trim($('#txtemailport').val()) == "") {
                $('#lblMsg').text('Please Enter the Email Port.');
                $('#txtemailport').focus();
                return false;
            }
            return true;
        }

    </script>
    <div id="Pbody_box_inventory">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Email Template Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Template Master</div>
               <div class="row">
                
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Email</label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromEmail" runat="server" AutoCompleteType="Disabled"  ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> Password</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPassword" AutoCompleteType="Disabled"  runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> SMTP HOST</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtsmtphost" AutoCompleteType="Disabled"  runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                        </div>
                        </div><div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">Email Port</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtemailport" AutoCompleteType="Disabled" Width="223px" MaxLength="6" TextMode="Number"  runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkuniversal" runat="server" Text="Isuniversal"  />
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" OnClientClick="return Validate()"  Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnUpdate" runat="server" ClientIDMode="Static" CssClass ="ItDoseButton"  Text="Update" OnClientClick="return Validate()" OnClick="btnUpdate_Click" Visible="false"/>&nbsp;
             <asp:Button ID="btnCancel"  TabIndex="7" runat="server" Text="Cancel" CssClass="ItDoseButton"  Visible="false" OnClick="btnCancel_Click" />
            <asp:Label ID="lblUpdatedID" runat="server" Visible="false"></asp:Label>
                        </div>
                    </div></div>
                   <div class="col-md-1"></div>
               </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <div class="pull-left">
                              <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle" onclick="ticketSearchByTr(0)"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Universal MailID</b>
            
            </div>
          
        </div>
          <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                     Results
                </div>
             <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr>
                    <td colspan="4">
               <asp:GridView ID="grdEmail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdEmail_RowCommand" OnRowDataBound="grdEmail_RowDataBound" Width="100%" Height="52px" Style="margin-left: 0px">
                            <Columns>
                                  <asp:TemplateField>
                                      <HeaderTemplate>S.No.</HeaderTemplate>
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                      <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                  <asp:TemplateField>
                                      <HeaderTemplate>Email ID</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmailID" runat="server" Text='<%#Eval("EmailID") %>'></asp:Label>
                                    </ItemTemplate>
                                      <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                  <asp:TemplateField>
                                      <HeaderTemplate>Password</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblPassword" runat="server" Text='<%#Eval("PASSWORD") %>'></asp:Label>
                                    </ItemTemplate>
                                      <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                  <asp:TemplateField>
                                      <HeaderTemplate>SMTP Host</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblsmtphost" runat="server" Text='<%#Eval("smtp_host") %>'></asp:Label>
                                    </ItemTemplate>
                                      <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField>
                                      <HeaderTemplate>Email Port</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblemailport" runat="server" Text='<%#Eval("email_port") %>'></asp:Label>
                                    </ItemTemplate>
                                      <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                  <asp:TemplateField>
                                      <HeaderTemplate>Created By</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmName" runat="server" Text='<%#Eval("EmName") %>'></asp:Label>
                                    </ItemTemplate>
                                      <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                  <asp:TemplateField>
                                      <HeaderTemplate>Date and Time</HeaderTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lbldateime" runat="server" Text='<%#Eval("UpdatedDate") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>'  ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUniversal" runat="server" Text='<%#Eval("UniversalEmail") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <AlternatingRowStyle CssClass="GridViewItemStyle" />
                        </asp:GridView>         
                    </td>
                </tr>
            </table>
             </div>
    </div>
</asp:Content>
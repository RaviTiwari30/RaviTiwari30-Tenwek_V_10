<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" EnableEventValidation="false" ValidateRequest="false" AutoEventWireup="true" CodeFile="smsmaster.aspx.cs" Inherits="Design_sms_smsmaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function validate() {
            if ($.trim($("#ddlTemplateName").val()) == "0") {
                $("#lblMsg").text('Please Select Sms Template Name');
                $("#ddlTemplateName").focus();
                return false;
            }
            if ($.trim($("#txtContentSMS").val()) == "") {
                $("#lblMsg").text('Please Enter Sms Content');
                $("#txtContentSMS").focus();
                return false;
            }
            
           

            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>
    <Ajax:ScriptManager ID="sm1" runat="server" />

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>SMS Master </b>
            <br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>



        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 20%; text-align: right">Sms Template Name :&nbsp;</td>
                    <td style="width: 70%; text-align: left">
                       <%-- <asp:TextBox ID="txtTemplateName" runat="server"  Width="280px" AutoCompleteType="Disabled"></asp:TextBox>--%>
                    <asp:DropDownList ID="ddlTemplateName" runat="server" Width="286px" CssClass="requiredField"  ClientIDMode="Static" AutoPostBack="true" OnSelectedIndexChanged="ddlTemplateName_SelectedIndexChanged"></asp:DropDownList>
                        <%--<span style="color: red; font-size: 10px;" >*</span>--%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right">SMS Content :&nbsp; 
                    </td>
                    <td style="width: 70%; text-align: left">
                        <asp:TextBox ID="txtContent" runat="server" Width="280px" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:DropDownList ID="ddlPatientInfo" runat="server" Width="114px"></asp:DropDownList></td>
                </tr>

            </table>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 100%; text-align: center">
                        <asp:Button ID="btnAppend" runat="server" Text="Append" OnClick="btnAppend_Click" CssClass="ItDoseButton" />
                    </td>
                </tr>

            </table>
            <div style="text-align: left">
              <asp:TextBox ID="txtContentSMS" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="780px" Height="60px" EnableTheming="false" ReadOnly="true" ForeColor="red"></asp:TextBox>
              <asp:Button ID="btnRemove" runat="server" Text="Remove" OnClick="btnRemove_Click" CssClass="ItDoseButton" />  
            </div>

            <table style="width: 100%; border-collapse: collapse;display:none">
                <tr>
                    <td style="width: 30%; text-align: right">Receipient :&nbsp; 
                    </td>
                    <td style="width: 70%; text-align: left;">
                        <asp:DropDownList ID="ddlReceipient" runat="server"  Width="286px">
                            <asp:ListItem Text="Patient" Value="PatientID"></asp:ListItem>
                            <asp:ListItem Text="Doctor" Value="Doctor"></asp:ListItem>
                            <asp:ListItem Text="Both" Value="Both"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 30%">Extra Reciepient&nbsp;(,&nbsp;Seprated)&nbsp;:&nbsp;
                    </td>
                    <td style="width: 70%; text-align: left">
                        <asp:TextBox ID="txtExtraReciepient" runat="server" Width="280px" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:Label ID="lblSMSId" runat="server" Visible="false"></asp:Label>
                    </td>
                </tr>
            </table>
             </div>
         <div class="POuter_Box_Inventory textCenter" >
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="save margin-top-on-btn" OnClientClick="return validate()" />
                 <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" CssClass="save margin-top-on-btn" Visible="false" />
            </div>
       
      <asp:Panel ID="pnlHide" runat="server" Visible="false">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:GridView ID="grdsms" runat="server" Width="100%" AutoGenerateColumns="false" OnRowCommand="grdsms_RowCommand" CssClass="GridViewStyle">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                             <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                         <ItemStyle CssClass="GridViewLabItemStyle" />
                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Template Name ">
                        <ItemTemplate>
                            <%#Eval("templatename")%>
                              <asp:Label ID="lblTemplateID" runat="server" Visible="false" Text='<%#Eval("templateID") %>'></asp:Label>
                            
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px"/>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="SMS Content">
                        <ItemTemplate>
                            <asp:TextBox ID="txtSmsTemp" runat="server" ReadOnly="true"  Height="60px" TextMode="MultiLine" Text='<%#Eval("sms") %>'></asp:TextBox>

                        </ItemTemplate>
                         <ItemStyle CssClass="GridViewLabItemStyle"  />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Reciepient " Visible="false">
                        <ItemTemplate>
                            <%#Eval("recipient") %>
                        </ItemTemplate>
                         <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                    </asp:TemplateField>
                  <asp:TemplateField HeaderText="Extra Reciepient " Visible="false">
                        <ItemTemplate>
                            <%#Eval("extrarecipient") %>
                        </ItemTemplate>
                         <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit" HeaderStyle-Width="50px">
                        <ItemTemplate>
                            <asp:ImageButton ID="btnedit" runat="server" CommandName="AEdit" CommandArgument='<%# Eval("id") %>' ImageUrl="~/Images/edit.png" />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                    </asp:TemplateField>
                    

                    <asp:TemplateField HeaderText="Cancel" HeaderStyle-Width="50px">
                        <ItemTemplate>
                            <asp:ImageButton ID="btnCancel" runat="server" CommandName="Acancel" CommandArgument='<%# Eval("id") %>' ImageUrl="~/Images/Delete.gif" />
                        </ItemTemplate>
                       <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                    </asp:TemplateField>
                </Columns>
                 <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
            </asp:GridView>
        </div>
        </asp:Panel>
    </div>
   


</asp:Content>


<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapReceipt.aspx.cs" Inherits="Design_Finance_MapReceipt" StylesheetTheme="Theme1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>--%>
    
 <asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">  
<script type="text/javascript" language="javascript" src="../Common/popcalendar.js"></script>


        <table cellpadding="0" cellspacing="0" style="width: 100%">
            <tr>
                <td style="text-align: center;" colspan="4">
                    <strong>Map Receipt</strong></td>
            </tr>
            <tr>
                <td style="width: 20%">
                </td>
                <td colspan="2">
                    <asp:ScriptManager id="ScriptManager1" runat="server">
                    </asp:ScriptManager></td>
                <td style="width: 30%">
                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                    Receipt Type</td>
                <td style="width: 30%">
                    <asp:UpdatePanel id="UpdatePanel3" runat="server">
                        <contenttemplate>
                            <asp:DropDownList ID="ddlReceiptType" runat="server" Width="240px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="width: 20%">
                    Receipt No.</td>
                <td style="width: 30%"><asp:UpdatePanel id="UpdatePanel4" runat="server">
                    <contenttemplate>
                        <asp:TextBox ID="txtReceiptNo" runat="server" AutoCompleteType="Disabled" CssClass="opdsearchbox1"
                            TabIndex="1"></asp:TextBox>
                    </ContentTemplate>
                    <triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                    Patient Registration No</td>
                <td style="width: 30%">
                    <asp:UpdatePanel id="UpdatePanel1" runat="server">
                        <contenttemplate>
<asp:TextBox id="txtRegNo" tabIndex=1 runat="server" CssClass="opdsearchbox1" AutoCompleteType="Disabled"></asp:TextBox> 
</contenttemplate>
                        <triggers>
<asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click"></asp:AsyncPostBackTrigger>
</triggers>
                    </asp:UpdatePanel></td>
                <td style="width: 20%">
                    Patient Name
                </td>
                <td style="width: 30%">
                    <asp:UpdatePanel id="UpdatePanel7" runat="server">
                        <contenttemplate>
<asp:TextBox id="txtPatientName" tabIndex=1 runat="server" CssClass="opdsearchbox1" AutoCompleteType="Disabled"></asp:TextBox> 
</contenttemplate>
                        <triggers>
<asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click"></asp:AsyncPostBackTrigger>
</triggers>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td style="width: 20%">
                    From Date</td>
                <td style="width: 30%">
                   
                     <asp:TextBox ID="txtFrmDt" runat="server" ClientIDMode="Static" Width="144px" TabIndex="10"
                            ToolTip="Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                            TargetControlID="txtFrmDt">
                        </cc1:CalendarExtender>

                </td>
                <td style="width: 20%">
                    To Date</td>
                <td style="width: 30%">
                  
                     <asp:TextBox ID="txtTDate" runat="server" ClientIDMode="Static" Width="144px" TabIndex="10"
                            ToolTip="Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy"
                            TargetControlID="txtTDate">
                        </cc1:CalendarExtender>



                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
                <td style="width: 20%">
                    <asp:UpdatePanel id="UpdatePanel2" runat="server">
                        <contenttemplate>
&nbsp;<asp:Button id="btnView" tabIndex=2 runat="server" CssClass="buttonsearch" Text="View" OnClick="btnView_Click"></asp:Button> 
</contenttemplate>
                    </asp:UpdatePanel></td>
                <td style="width: 30%">
                </td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center">
                    <asp:UpdatePanel id="UpdatePanel11" runat="server">
                        <contenttemplate>
<asp:Label id="lblMsg" runat="server" Font-Size="Small" ForeColor="Red" Font-Bold="True"></asp:Label>
</contenttemplate>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td colspan="2">
                    <strong>Receipt Details</strong></td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center">
                    <asp:UpdatePanel id="UpdatePanel8" runat="server">
                        <contenttemplate>
<asp:GridView id="GridView1" runat="server" CssClass="generaltext1" Width="807px" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" __designer:wfdid="w29"><Columns>
<asp:BoundField DataField="Date" HeaderText="Date"></asp:BoundField>
    <asp:BoundField DataField="PName" HeaderText="Patient Name" />
<asp:BoundField DataField="PatientID" HeaderText="RegistrationNo"></asp:BoundField>
    <asp:BoundField DataField="ReceiptNo" HeaderText="Receipt No" />
    <asp:BoundField DataField="AmountPaid" HeaderText="Amount" />
<asp:CommandField ShowSelectButton="True" HeaderText="View"></asp:CommandField>
<asp:TemplateField Visible="False"><ItemTemplate>
<asp:Label id="lblReceiptNo" runat="server" Text='<%# Eval("ReceiptNo") %>'></asp:Label>
</ItemTemplate>
</asp:TemplateField>
    <asp:TemplateField Visible="False">
        <ItemTemplate>
            <asp:Label ID="lblLedgerTransactionNo" runat="server" Text='<%# Eval("LedgerTransactionNo") %>'></asp:Label>
        </ItemTemplate>
    </asp:TemplateField>
</Columns>

<HeaderStyle CssClass="generaltext"></HeaderStyle>

<AlternatingRowStyle CssClass="generaltext1"></AlternatingRowStyle>
</asp:GridView> 
</contenttemplate>
                        <triggers>
<asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click"></asp:AsyncPostBackTrigger>
</triggers>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td colspan="2">
                    <strong>Patient Admission Details </strong>
                </td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:UpdatePanel id="UpdatePanel5" runat="server">
                        <contenttemplate>
<asp:GridView id="grdPatient" runat="server" CssClass="generaltext1" Width="807px" __designer:wfdid="w37" OnSelectedIndexChanged="grdPatient_SelectedIndexChanged" AutoGenerateColumns="False"><Columns>
<asp:BoundField DataField="PatientID" HeaderText="Reg. No.">
<ItemStyle HorizontalAlign="Left"></ItemStyle>

<HeaderStyle Width="100px" HorizontalAlign="Left"></HeaderStyle>
</asp:BoundField>
<asp:BoundField DataField="PName" HeaderText="Name">
<ItemStyle HorizontalAlign="Left"></ItemStyle>

<HeaderStyle Width="250px" HorizontalAlign="Left"></HeaderStyle>
</asp:BoundField>
<asp:TemplateField HeaderText="Age/Sex">
<ItemStyle Width="100px" HorizontalAlign="Center"></ItemStyle>

<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
<ItemTemplate>
<asp:Label id="lblAgeSex" runat="server" Text='<%# Eval("Age") + "/" +Eval("Gender") %>' __designer:wfdid="w35"></asp:Label>
</ItemTemplate>
</asp:TemplateField>
<asp:BoundField DataField="Address" HeaderText="Address"></asp:BoundField>
<asp:BoundField DataField="RName" HeaderText="Room">
<ItemStyle Width="100px" HorizontalAlign="Left"></ItemStyle>

<HeaderStyle Width="100px" HorizontalAlign="Left"></HeaderStyle>
</asp:BoundField>
<asp:BoundField DataField="DName" HeaderText="Doctor Name"></asp:BoundField>
<asp:BoundField DataField="Company_Name" HeaderText="Sponsor Name"></asp:BoundField>
<asp:BoundField DataField="TransactionID" HeaderText="IPD No.">
<ItemStyle Width="100px" HorizontalAlign="Left"></ItemStyle>

<HeaderStyle HorizontalAlign="Left"></HeaderStyle>
</asp:BoundField>
<asp:CommandField ShowSelectButton="True">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>

<ItemStyle Width="75px" HorizontalAlign="Center"></ItemStyle>
</asp:CommandField>
</Columns>

<HeaderStyle CssClass="generaltext"></HeaderStyle>
</asp:GridView> 
</contenttemplate>
                        <triggers>
<asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click"></asp:AsyncPostBackTrigger>
</triggers>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                    Map Receipt No
                </td>
                <td style="width: 30%">
                    <asp:UpdatePanel id="UpdatePanel6" runat="server">
                        <contenttemplate>
                    <asp:TextBox ID="txtReceiptMap" runat="server"></asp:TextBox>
</contenttemplate>
                    </asp:UpdatePanel></td>
                <td style="width: 20%">
                    To This IPD No.</td>
                <td style="width: 30%">
                    <asp:UpdatePanel id="UpdatePanel9" runat="server">
                        <contenttemplate>
                    <asp:TextBox ID="txtTransctionID" runat="server"></asp:TextBox>
</contenttemplate>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
                <td style="width: 20%"><asp:UpdatePanel id="UpdatePanel10" runat="server">
                    <contenttemplate>
&nbsp;<asp:Button id="btnSave" tabIndex=2 runat="server" CssClass="buttonsearch" Text="Save" __designer:wfdid="w7" OnClick="btnSave_Click"></asp:Button> 
</contenttemplate>
                </asp:UpdatePanel>
                </td>
                <td style="width: 30%">
                </td>
            </tr>
        </table>
    <%--
    </div>
    </form>
</body>
</html>--%>

</asp:Content>

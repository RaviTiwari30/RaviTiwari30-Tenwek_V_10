<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocSharePayoutDoctor.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_DocAccount_DocSharePayoutDoctor" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <cc1:ToolkitScriptManager runat="server" ID="scrManager1"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b>Doctor Transactions (OPD-IPD)- Revenues & Collections</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                      <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ID="ucFromDate" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ID="ucToDate" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="ucToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Doctor Wise
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDoctor" runat="server">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rbtOPDIPD" runat="server" RepeatLayout="Flow"
                        RepeatDirection="Horizontal" >
                        <asp:ListItem Selected="True" Value="OPD">OPD</asp:ListItem>
                        <asp:ListItem Value="IPD">IPD</asp:ListItem>
                        <asp:ListItem>ALL</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Transaction
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rdbtran" runat="server"  RepeatDirection="Horizontal"  RepeatLayout="Flow">
                        <asp:ListItem Text="BillDate" Selected="True" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Receipt Date" Value="2"></asp:ListItem>
                    </asp:RadioButtonList>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Report Format
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rbtReportType" runat="server"
                        RepeatDirection="Horizontal"  RepeatLayout="Flow"
                        OnSelectedIndexChanged="rbtReportType_SelectedIndexChanged">
                        <asp:ListItem Selected="True" Value="S">Summary</asp:ListItem>
                        <asp:ListItem Value="D">Detail</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                    <asp:CheckBox ID="chkdoctorwise" runat="server" Text="DoctorWise" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                </div>
            </div>
            <div class="row" style="text-align: center">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" Width="65px" OnClick="btnSearch_Click" />
            </div>
                </div>
                <div class="col-md-1"></div>
            </div>
          
        </div>
    </div>




</asp:Content>

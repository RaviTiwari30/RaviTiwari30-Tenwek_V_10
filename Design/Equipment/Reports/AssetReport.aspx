<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetReport.aspx.cs" Inherits="Design_IPD_AssetReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
    <link href="../../../Styles/grid24.css" rel="stylesheet" type="text/css" />
    <style>
        .ItDoseDropdownbox
        {
            margin-top:0px;
        }
    </style>
</head>
<script type="text/css"> 
     function cal() {
         var ce = $find("ce1"); ce.hide();
     }
</script>

<body style="margin-top: 1px; margin-left: 1px;overflow:hidden;">
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="POuter_Box_Inventory" style="width: 1031px;">
                <asp:ScriptManager ID="sc" runat="server"></asp:ScriptManager>
                <div style="text-align: center">
                    <b>Asset List </b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <div class="Purchaseheader">
                    Report Critaria
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <div class="row">
                    <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="100%" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select From Date" Width="100%" ClientIDMode="Static" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                            <label class="pull-left">List Type </label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rdoListType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist" OnSelectedIndexChanged="rdoListType_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Text="Active" Value="1" />
                                <asp:ListItem Text="Deactive" Value="2" />
                            </asp:RadioButtonList>
                    </div>
                     
                </div>

                <div class="row">
                    <div class="col-md-3">
                            <label class="pull-left">Report Type </label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                       <asp:DropDownList ID="ddlReportType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged" CssClass="ItDoseDropdownbox">
                            </asp:DropDownList>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <asp:CheckBoxList ID="chkItems" runat="server" Visible="false" RepeatColumns="2" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" />
            </div>
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetTypeReport.aspx.cs" Inherits="Design_Equipment_Masters_AssetTypeReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
    <link href="../../../Styles/grid24.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .ItDoseDropdownbox
        {
            margin-top:0px;
        }
    </style>
</head>
<body style="overflow:hidden;">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="sc" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory" style="width:100%;">
            <div class="POuter_Box_Inventory" style="width:100%;">
                <div style="text-align: center">
                    <b>Asset Type Reports</b><br />
                    <asp:Label ID="lblmsg" runat="server" ForeColor="Red"></asp:Label>
                </div>                
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;width:100%;">
                <div class="row">
                    <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="150px" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="fromdate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                    </div>
                     <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select From Date" Width="150px" ClientIDMode="Static" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="todate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                            <label class="pull-left">Asset Type</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlassettype" runat="server" CssClass="ItDoseDropdownbox" Width="100%">
                            </asp:DropDownList>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rdoListType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist">
                                <asp:ListItem Selected="True" Text="Active" Value="1" />
                                <asp:ListItem Text="Deactive" Value="2" />
                            </asp:RadioButtonList>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" CssClass="ItDoseButton" />
            </div>
        </div>
    </form>
</body>
</html>

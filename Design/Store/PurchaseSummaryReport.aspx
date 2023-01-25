<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="PurchaseSummaryReport.aspx.cs" Inherits="Design_Purchase_PurchaseSummaryReport" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script src="../../Scripts/Message.js" type="text/javascript" ></script> 
    <script type="text/javascript" >

        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();
            });

        });



        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');

                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#tbAppointment table").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }



    </script>
     
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                    <b>Purchase Summary Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
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
                             <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                 To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ></asp:TextBox>
                            <cc1:CalendarExtender ID="fromdate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                  Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGroup" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroup_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                        <div class="row">
                             <div class="col-md-3">
                            <label class="pull-left">
                                 Store Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                             <asp:RadioButtonList ID="rdbgrp" runat="server" RepeatDirection="Horizontal" AutoPostBack="True"
                                OnSelectedIndexChanged="rdbgrp_SelectedIndexChanged">
                                <asp:ListItem Value="ALL">All</asp:ListItem>
                                <asp:ListItem Value="11">Medical Store</asp:ListItem>
                                <asp:ListItem Value="28">General Store</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlItem" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                <table  style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td colspan="2"   style="display:none">
                            <asp:RadioButtonList ID="rbtBilled" runat="server" RepeatDirection="Horizontal" AutoPostBack="True"
                                OnSelectedIndexChanged="rbtBilled_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="All">ALL</asp:ListItem>
                                <asp:ListItem Value="1">Billed</asp:ListItem>
                                <asp:ListItem Value="0">Not-Billed</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td  style="width: 15%;text-align:right" >
                            Item Type :&nbsp;
                        </td>
                        <td style="width: 15%" >
                            <asp:RadioButtonList ID="rbtType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rbtType_SelectedIndexChanged">
                                <asp:ListItem Value="All">ALL</asp:ListItem>
                                <asp:ListItem Value="GP">Shri Gopal Pharmacy</asp:ListItem>
                                <asp:ListItem Value="HS" Selected="True">Hospital Store</asp:ListItem>
                                <asp:ListItem Value="IMP">Implants</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="width: 15%; text-align: right" >
                        </td>
                        <td style="width: 15%" >
                        </td>
                    </tr>
                </table>
            </div>
            
            <div class="POuter_Box_Inventory" style="text-align: center;">
                &nbsp;&nbsp;
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton"
                    OnClick="btnSearch_Click" ClientIDMode="Static" />
            </div>
        </div>
</asp:Content>

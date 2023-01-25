<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Mortuary_PostMortemReport.aspx.cs" Inherits="Design_Mortuary_Mortuary_PostMortemReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
               // ChkDate();
            });

            $("#btnSearch").click(function () {

                $("#lblMsg").text("");
                $("#btnSearch").val("Searching...").attr("disabled", true);

                //Call service to get report data.
                $.ajax({
                    url: "Services/Mortuary.asmx/MortuaryPostmortemStatusReport",
                    data: '{fromDate:"' + $.trim($("#txtFromDate").val()) + '",toDate:"' + $("#txtToDate").val() + '",status:"' + $("#ddlStatus option:selected").text() + '",user_ID:"' + $("#lblUser").text() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            window.open("../common/Commonreport.aspx");
                        }
                        else {
                            DisplayMsg("MM04", "lblMsg");
                        }
                        $("#btnSearch").val("Search").attr("disabled", false);
                    },
                    error: function (xhr, status) {
                        DisplayMsg("MM05", "lblMsg");
                        $("#btnSearch").val("Search").attr("disabled", false);
                    }
                });
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#lblMsg").text("To date can not be less than from date!");
                        $("#btnSearch").attr("disabled", "disabled");
                    }
                    else {
                        $("#lblMsg").text("");
                        $("#btnSearch").removeAttr("disabled");
                    }
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Corpse Post-Mortem Status Report</strong>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            <asp:Label ID="lblUser" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" Style="display: none;" />
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
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server" ClientIDMode="Static" ToolTip="Select Status" TabIndex="1" Width="">
                                <asp:ListItem Text="Requested" Value="1" Selected="True" />
                                <asp:ListItem Text="Sent" Value="2" />
                                <asp:ListItem Text="Completed" Value="3" />
                                <asp:ListItem Text="All" Value="4" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" Width="" TabIndex="2" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" Width="" TabIndex="3" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" value="Search" class="ItDoseButton" tabindex="4" title="Click To Search" />
        </div>
    </div>
</asp:Content>


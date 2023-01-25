<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DrugCategoryReport.aspx.cs" Inherits="Design_Store_DrugCategoryReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conetent1" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

            showSelectedType();
        });


        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
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

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                       $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
                   }
                   else {
                       $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
                   }
               }

               var showSelectedType = function () {
                   var type = $("#dllType").val();
                   if (type == "1") {
                       $("#ddlDrugCategory").show();
                       $("#ddlItemType").hide();
                   }
                   else {
                       $("#ddlDrugCategory").hide();
                       $("#ddlItemType").show();
                   }

               }

    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Dangerous Drug/Item Type Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"
                        TabIndex="1" Width="110px"></asp:TextBox>
                    <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"
                        Width="110px" TabIndex="2"></asp:TextBox>
                    <cc1:CalendarExtender ID="Todatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">
                        <asp:DropDownList ID="dllType" runat="server" ClientIDMode="Static" onchange="showSelectedType()">
                            <asp:ListItem Value="1" Selected="True">Dangerous Drug</asp:ListItem>
                           <%-- <asp:ListItem Value="2">Item Type</asp:ListItem>--%>
                        </asp:DropDownList>

                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <%--<asp:DropDownList ID="ddlDrugCategory" runat="server" ClientIDMode="Static">
                        <asp:ListItem>All</asp:ListItem>
                        <asp:ListItem>H1-Schedule Type</asp:ListItem>
                        <asp:ListItem>H2-Schedule Type</asp:ListItem>
                    </asp:DropDownList>--%>

                    <asp:DropDownList runat="server" ID="ddlDrugCategory" ClientIDMode="Static"></asp:DropDownList>

                    <asp:DropDownList ID="ddlItemType" runat="server" Style="display: none;" ClientIDMode="Static">
                        <asp:ListItem>All</asp:ListItem>
                        <asp:ListItem>Vital</asp:ListItem>
                        <asp:ListItem>Essential</asp:ListItem>
                        <asp:ListItem>Deseriable</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre &nbsp;" />
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21">
                    <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                    </asp:CheckBoxList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                ToolTip="Click To Open Report " ClientIDMode="Static" TabIndex="3" />
        </div>
    </div>
</asp:Content>

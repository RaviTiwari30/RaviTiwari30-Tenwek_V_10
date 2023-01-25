<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDConsultationVisitReport.aspx.cs" Inherits="Design_IPD_IPDConsultationVisitReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                     
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                     

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
        $(function () {
            $("[id*=chkSubGroups]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlSubGroups] input").attr("checked", "checked");
                } else {
                    $("[id*=chlSubGroups] input").removeAttr("checked");
                }
            });
            $("[id*=chlSubGroups] input").bind("click", function () {
                if ($("[id*=chlSubGroups] input:checked").length == $("[id*=chlSubGroups] input").length) {
                    $("[id*=chkSubGroups]").attr("checked", "checked");
                } else {
                    $("[id*=chkSubGroups]").removeAttr("checked");
                }
            });
            $("[id*=chkItems]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlItems] input").attr("checked", "checked");
                } else {
                    $("[id*=chlItems] input").removeAttr("checked");
                }
            });
            $("[id*=chlItems] input").bind("click", function () {
                if ($("[id*=chlItems] input:checked").length == $("[id*=chlItems] input").length) {
                    $("[id*=chkItems]").attr("checked", "checked");
                } else {
                    $("[id*=chkItems]").removeAttr("checked");
                }
            });
            $("[id*=chkdoctor]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkDoctors] input").attr("checked", "checked");
                } else {
                    $("[id*=chkDoctors] input").removeAttr("checked");
                }
            });
            $("[id*=chkDoctors] input").bind("click", function () {
                if ($("[id*=chkDoctors] input:checked").length == $("[id*=chkDoctors] input").length) {
                    $("[id*=chkdoctor]").attr("checked", "checked");
                } else {
                    $("[id*=chkdoctor]").removeAttr("checked");
                }
            });

            $("[id*=chkPanel]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlPanel] input").attr("checked", "checked");
                } else {
                    $("[id*=chlPanel] input").removeAttr("checked");
                }
            });
            $("[id*=chlItems] input").bind("click", function () {
                if ($("[id*=chlItems] input:checked").length == $("[id*=chlItems] input").length) {
                    $("[id*=chkPanel]").attr("checked", "checked");
                } else {
                    $("[id*=chkPanel]").removeAttr("checked");
                }
            });

        });
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>IPD Consultation Report ( Currently Admitted Patient ) </b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left; display: none;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="text-align: center; width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 20%; text-align: right">From Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 25%;">
                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select From Date" />
                        <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right; width: 20%">To Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 25%;">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select to Date" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>

                <tr>
                    <td>Search By Name :</td>
                    <td style="text-align: left">
                        <input type="text" id="txtDoctor" style="width: 250px" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: left; width: 107px; border: solid 1px">
                        <asp:CheckBox ID="chkdoctor" runat="server" Text="Doctors" CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="4" style="width: 854px">
                        <div style="overflow: scroll; height: 207px; width: 842px; text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chkDoctors" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                <tr id="tr_Panel1list" runat="server">
                    <td style="text-align: right;">Panel Name :&nbsp;   
                    </td>
                    <td style="text-align: left">
                        <input type="text" id="txtPanelName" onkeyup="SearchCheckbox(this,'#chlPanel')" style="width: 250px" />
                    </td>

                </tr>
                <tr>
                    <td style="text-align: left; width: 107px; border: solid 1px">
                        <asp:CheckBox ID="chkPanel" runat="server" Text="Panels" CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="4" style="width: 854px">
                        <div style="overflow: scroll; height: 207px; width: 842px; text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlPanel" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
          <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-22">
                <div class="row">
                    <div class="col-md-3">

                        <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                    </div>
                    <div class="col-md-21">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                    </div>
                </div>
            </div>
            <div class="col-md-1"></div>
        </div></div>
    <div class="POuter_Box_Inventory" style="text-align: center">
        &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton"
            OnClick="btnSearch_Click" ToolTip="Click to Open Report " TabIndex="5" />
    </div>

</asp:Content>


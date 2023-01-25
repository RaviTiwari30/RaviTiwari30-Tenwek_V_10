<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TurnArountTimeReport.aspx.cs"
    Inherits="Design_Lab_TurnArountTimeReport" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

   <%-- <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>--%>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });

            $('#ToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '1' || $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '3') {
                //  $("#<%=txtCRNo.ClientID %>").val('').prop('readOnly', 'true');
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $('input[id=chkAll]').attr("checked", true);
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '2') {
                //$("#<%=txtCRNo.ClientID %>").removeAttr('readOnly');
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13)
                    $('#btnSearch').click();
            });
            show();
            $("#<%=chkAll.ClientID %>").click(function () {
                $("#<%= chkInvestigation.ClientID %> input:checkbox").attr('checked', this.checked).length;
            });
            $("[id$=chkInvestigation]").click(function () {
                // alert($("#list input:checked").length);
                if ($("#<%= chkInvestigation.ClientID %> ").length == $("#list input:checked").length) {
                    $('[id$=chkAll]').attr("checked", "checked");
                }
                else {
                    $('[id$=chkAll]').removeAttr("checked");
                }
            });
        });
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
    </script>



    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Turn Around Time Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">

                <div class="col-md-24">
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                       

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" MaxLength="20" data-title="Enter UHID No." ClientIDMode="Static" AutoCompleteType="Disabled" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal" onclick="show();">
                                <asp:ListItem Text="OPD" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Emergency" Value="3"></asp:ListItem>
                                <asp:ListItem Text="ALL" Value="0"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIPDNo" Text="IPD No. :&nbsp;" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCRNo" runat="server" AutoCompleteType="Disabled" data-title="Enter IPD No." ClientIDMode="Static" TabIndex="2" Style="display: none" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLabNo" runat="server" AutoCompleteType="Disabled" data-title="Enter Barcode No." ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPName" runat="server"  AutoCompleteType="Disabled" data-title="Enter Patient Name" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server">
                                <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
                                <asp:ListItem Value="1">Approved</asp:ListItem>
                                <asp:ListItem Value="2">Not-Aproved</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" Width="160px" AutoCompleteType="Disabled" data-title="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate"></cc1:CalendarExtender>
                            <asp:TextBox ID="txtFromTime" runat="server" Width="80px" ClientIDMode="Static" AutoCompleteType="Disabled" data-title="Enter Time"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="meetxtFromTime" Mask="99:99" TargetControlID="txtFromTime" AcceptAMPM="true" AcceptNegative="None" MaskType="Time"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="metxtFrTime" ControlExtender="meetxtFromTime" ControlToValidate="txtFromTime" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="160px" AutoCompleteType="Disabled" data-title="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ToDate"></cc1:CalendarExtender>
                            <asp:TextBox ID="txtToTime" runat="server" Width="80px" ClientIDMode="Static" AutoCompleteType="Disabled" data-title="Enter Time"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="meetxtToTime" Mask="99:99" TargetControlID="txtToTime" AcceptAMPM="true" AcceptNegative="None" MaskType="Time"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime" ControlExtender="meetxtToTime" ControlToValidate="txtToTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="PDF" Value="PDF" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Excel" Value="Excel"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubCategory" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                            Search By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" onkeyup="SearchCheckbox(this,'#chkInvestigation')"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
            <div style="text-align: left;">
                <table width="100%">
                    <tr>
                        <td style="width: 12%; text-align: right; border: groove">
                            <asp:CheckBox ID="chkAll" runat="server" Text="Select All" /></td>
                        <td colspan="2" style="border: groove">
                            <div style="overflow: scroll; height: 290px; width: 100%; text-align: left;" class="border" id="Div1">
                                <asp:CheckBoxList ID="chkInvestigation" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" ClientIDMode="Static"></asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory center">
                <asp:CheckBox ID="chkOldData" runat="server" Text="Old Data" Visible="false" />&nbsp;
                <asp:Button ID="btnSearch" ClientIDMode="Static" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
           
        </div>
    </div>
</asp:Content>

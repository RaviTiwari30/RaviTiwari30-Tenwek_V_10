<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="InvestigationAnalysisReport.aspx.cs" Inherits="Design_OPD_InvestigationAnalysisReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            blockUIOnRequest();
        });
        var blockUIOnRequest = function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $modelBlockUI();
            });
            prm.add_endRequest(function () {
                $modelUnBlockUI();
            });
        }
 </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.scroll').slimScroll({
                color: '#008AFF',
                height: '150px',
            });
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
                        $('#<%=btnSearch.ClientID %>,#<%=btnItems.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnItems.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }

    </script>
    <script type="text/javascript">
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
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Item Analysis Report</b><br />
         <asp:UpdatePanel ID="uppanel" runat="server">
    <ContentTemplate>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></ContentTemplate>
    </asp:UpdatePanel>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left">
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
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select From Date" />
                            <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select to Date" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                View Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBoxList ID="chkOPDIPD" runat="server" RepeatColumns="2">
                                <asp:ListItem Selected="True">IPD</asp:ListItem>
                                <asp:ListItem Selected="True">OPD</asp:ListItem>
                            </asp:CheckBoxList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:RadioButtonList ID="rdbReport" runat="server" RepeatDirection="Horizontal"
                                RepeatColumns="3" Style="margin-left: 0px">
                                <asp:ListItem Text="Detailed" Value="D" Selected="True" />
                                <asp:ListItem Text="Summarised-Itemwise" Value="SI"></asp:ListItem>
                                <asp:ListItem Text="Summarised" Value="S"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sub-Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"
                                AutoPostBack="false" RepeatColumns="3">
                                <asp:ListItem Selected="True" Value="1" Text="Group Wise" />
                                <asp:ListItem Text="Doctor Wise" Value="2" />
                                <asp:ListItem Text="Panel Wise" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Format Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                             <asp:RadioButtonList ID="rblReportFormatType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" 
                               AutoPostBack="false" RepeatColumns="3" >
                             <asp:ListItem Selected="True" Value="PDF" Text="PDF" />
                             <asp:ListItem Text="Excel" Value="Excel" />
                             </asp:RadioButtonList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                        </div>
                    </div>
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
                    <div class="row" style="display:none">
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="rdoBillDate" runat="server" RepeatDirection="Horizontal" Width="519px">
                                <asp:ListItem Value="0" Selected="True">On Entry Date</asp:ListItem>
                                <asp:ListItem Value="1">On BillDate Without Disc.</asp:ListItem>
                                <asp:ListItem Value="2">On BillDate With Disc.</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>

                                 <div class="row">
                                     <span style="font-size:xx-small;font-style:italic;color:red;font-weight:bold">NOTE: This report is generated as per entry date.</span>
                                     </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Additional Search Criteria
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="width: 10%; text-align: left; border: groove">
                        <asp:CheckBox ID="chkItemGroups" runat="server" Text="Item Groups" AutoPostBack="true"
                            OnCheckedChanged="chkItemGroups_CheckedChanged" CssClass="ItDoseCheckbox" />
                        &nbsp;</td>
                    <td style="text-align: left; width: 100%; border: groove" colspan="6">
                        <div style="text-align: left;" class="scroll">
                            <asp:CheckBoxList ID="ddlGroups" runat="server" RepeatColumns="6" ClientIDMode="Static" RepeatLayout="Table" AutoPostBack="true"
                                RepeatDirection="Horizontal" OnSelectedIndexChanged="ddlGroups_SelectedIndexChanged">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-7"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Sub Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearchSubCategory" onkeyup="SearchCheckbox(this,'#chlSubGroups')" />
                        </div>
                        <div class="col-md-8"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <table style="width: 100%;">
                <tr>
                    <td style="text-align: left; width: 10%; border: groove">
                        <asp:CheckBox ID="chkSubGroups" runat="server" Text="Sub Groups" AutoPostBack="false"
                            OnCheckedChanged="chkSubGroups_CheckedChanged" CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="6" style="width: 100%; border: groove">
                        <div style="text-align: left;" class="scroll">
                            <asp:CheckBoxList ID="chlSubGroups" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-5"></div>
                        <div class="col-md-2">
                            <asp:Button ID="btnItems" runat="server" Text="Items" CausesValidation="False"
                                OnClick="btnItems_Click" CssClass="ItDoseButton" ToolTip="Click to Select Items"
                                TabIndex="4" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="Text1" onkeyup="SearchCheckbox(this,'#chlItems')" />
                        </div>
                        <div class="col-md-8"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>
            <div class="row"></div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: left; width: 10%; border: groove">
                        <asp:CheckBox ID="chkItems" runat="server" Text="Items" AutoPostBack="false" OnCheckedChanged="chkItems_CheckedChanged"
                            CssClass="ItDoseCheckbox" />
                    </td>
                    <td style="text-align: left; width: 100%; border: groove" colspan="6">
                        <div style="text-align: left;" class="scroll">
                            <asp:CheckBoxList ID="chlItems" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-7"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="Text2" onkeyup="SearchCheckbox(this,'#chkDoctors')" />
                        </div>
                        <div class="col-md-8"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>
            <div class="row"></div>
            <table style="width: 100%">
                <tr id="tr_Doctorlist" runat="server">
                    <td style="text-align: left; width: 10%; border: groove">
                        <asp:CheckBox ID="chkdoctor" runat="server" Text="Doctors" CssClass="ItDoseCheckbox" />
                    </td>
                    <td style="text-align: left; width: 100%; border: groove" colspan="6">
                        <div style="text-align: left;" class="scroll">
                            <asp:CheckBoxList ID="chkDoctors" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-7"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Panel Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="Text3" onkeyup="SearchCheckbox(this,'#chlPanel')" />
                        </div>
                        <div class="col-md-8"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>
            <div class="row"></div>

            <table style="width: 100%">
                <tr id="tr_Panellist" runat="server">
                    <td style="text-align: left; width: 10%; border: groove">
                        <asp:CheckBox ID="chkPanel" runat="server" Text="Panels" CssClass="ItDoseCheckbox" />
                    </td>
                    <td style="text-align: left; width: 100%; border: groove" colspan="6">
                        <div style="text-align: left;" class="scroll">
                            <asp:CheckBoxList ID="chlPanel" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>

            </table>
            &nbsp;
        </div>
    </div>
    <div class="POuter_Box_Inventory" style="text-align: center">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton"   OnClientClick="blockUIOnRequest()"
            OnClick="btnSearch_Click" ToolTip="Click to Open Report " TabIndex="5" /></ContentTemplate></asp:UpdatePanel>
    </div>
</asp:Content>

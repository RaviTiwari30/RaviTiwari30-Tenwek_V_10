<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OutSourceReport.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Lab_OutSourceReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
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
        function checkAllOutSource() {
            var status = $('#<%= chkOutSource.ClientID %>').is(':checked');

            if (status == true) {
                $('.checkAllOutSource input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".checkAllOutSource input[type=checkbox]").attr("checked", false);
            }
        }
        function chkOutSourceCon() {
            if (($('#<%= chkOurSourcelab.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkOurSourcelab.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkOutSource.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkOutSource.ClientID %>').attr("checked", false);
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Out Source Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
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
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> 
                            <asp:TextBox ID="txtfromDate" runat="server" ToolTip="Click To Select From Date" AutoCompleteType="Disabled"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtfromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" AutoCompleteType="Disabled"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Report Format
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:RadioButtonList ID="rblReportFormat" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Text="Excel"></asp:ListItem>
                            <asp:ListItem Value="2" Text="PDF" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Lab Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                          <asp:RadioButtonList ID="rdbitem" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                            <asp:ListItem Text="OPD" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                            <asp:ListItem Value="3">Emergency</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                        
                    </div>
                        <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                             <asp:CheckBox ID="chkOutSource" runat="server" ClientIDMode="Static" Text="OutSource Lab " onclick="checkAllOutSource();" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                          <asp:CheckBoxList ID="chkOurSourcelab" runat="server" RepeatDirection="Horizontal" 
                            onclick="chkOutSourceCon()" CssClass="checkAllOutSource ItDoseCheckboxlist" ClientIDMode="Static"></asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
        </div>
    </div>
</asp:Content>



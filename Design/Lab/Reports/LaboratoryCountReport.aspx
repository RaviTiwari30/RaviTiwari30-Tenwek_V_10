<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="LaboratoryCountReport.aspx.cs" Inherits="Design_Lab_LaboratoryCountReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            $('#ddlDepartment').chosen();
            $('input').keyup(function () {
                if (event.keyCode == 13)
                    $('#btnReport').click();
            })
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
                        $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');

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
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Laboratory Count Report</b>&nbsp;<br />
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
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()"
                                RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist"
                                runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                       

                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                Count Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbCountReport" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">Investigation</asp:ListItem>
                                <asp:ListItem Value="1">Observation</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div> 
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Lab Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbitem" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                                <asp:ListItem Text="OPD" Value="1" ></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                <asp:ListItem Value="3" Text="Emergency"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static" ></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Age From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromAge" runat="server" ClientIDMode="Static" data-title="Enter From Age" MaxLength="4" AutoCompleteType="Disabled" Width="70px" />
                            <cc1:FilteredTextBoxExtender ID="ftbeFromAge" runat="server" TargetControlID="txtFromAge" FilterType="Numbers,Custom" ValidChars="." />
                            <asp:DropDownList ID="ddlAgeFrom" runat="server" Width="149px">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem>DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Age To 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToAge" runat="server" ClientIDMode="Static" data-title="Enter To Age" MaxLength="4" AutoCompleteType="Disabled" Width="70px" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtToAge" FilterType="Numbers,Custom" ValidChars="." />
                            <asp:DropDownList ID="ddlAgeTo" runat="server" Width="149px">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem>DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblGender" runat="server" ToolTip="Select Gender" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Male" Value="1" />
                                <asp:ListItem Text="Female" Value="2" />
                                <asp:ListItem Text="Both" Value="3" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled"
                            data-title="Select From Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static"  AutoCompleteType="Disabled"
                            data-title="Select From Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ToDate">
                        </cc1:CalendarExtender>
                        </div>
                       
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" ClientIDMode="Static" CssClass="ItDoseButton" Text="Report" />
        </div>


    </div>
</asp:Content>


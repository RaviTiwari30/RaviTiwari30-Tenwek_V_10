<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ReturnSearch.aspx.cs" Inherits="Design_Store_ReturnSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">

        $(function () {
            $('#cmbdept').chosen();
            $('#txtFrmDt').change(function () {
                ChkDate();

            });

            $('#txtTDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFrmDt').val() + '",DateTo:"' + $('#txtTDate').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnView').attr('disabled', 'disabled');                      
                        $(".GridViewStyle").hide();
                        $("#tbAppointment table").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnView').removeAttr('disabled');
                    }
                }
            });

        }
        
        $(document).ready(function () {
            
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
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Department Return Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                                <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Return No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDocumentNo" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                       <div class="col-md-3">
                            <label class="pull-left">
                             Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:DropDownList ID="cmbdept" runat="server" TabIndex="4" ClientIDMode="Static">
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
                            <asp:TextBox ID="txtFrmDt" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="frmdate" TargetControlID="txtFrmDt" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="txtTDate" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="caltodate" TargetControlID="txtTDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
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
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                            <asp:Button ID="btnView" runat="server" CssClass="ItDoseButton" Text="View" OnClick="btnView_Click1"
                                ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div>
            <asp:GridView ID="grdPatient" runat="server" CssClass="GridViewStyle" OnRowCommand="grdPatient_RowCommand" AutoGenerateColumns="False" Width="100%">
                <Columns>
                    <asp:BoundField DataField="ReturnNo" HeaderText="Return No.">
                        <ItemStyle Width="100px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ReturnFrom" HeaderText="Return From">
                        <ItemStyle Width="200px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ReturnTo" HeaderText="Return To">
                        <ItemStyle Width="200px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CentreName" HeaderText="Centre Name">
                        <ItemStyle Width="100px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                      <asp:BoundField DataField="ReturnBy" HeaderText="Return By">
                        <ItemStyle Width="100px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                      <asp:BoundField DataField="Date" HeaderText="Return Date">
                        <ItemStyle Width="100px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:ButtonField HeaderText="Print" Text="Print" CommandName="Print">
                        <ItemStyle Width="75px" CssClass="GridViewItemStyle"></ItemStyle>
                        <HeaderStyle HorizontalAlign="Center" CssClass="GridViewHeaderStyle" />
                    </asp:ButtonField>
                </Columns>
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle"></HeaderStyle>
            </asp:GridView>
            </div>
        </div>
       

    </div>
</asp:Content>

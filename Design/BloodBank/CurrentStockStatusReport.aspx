<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CurrentStockStatusReport.aspx.cs" Inherits="Design_BloodBank_CurrentStockStatusReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
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
            $('#txtcollectionfrom').change(function () {
                ChkDate();
            });
            $('#txtcollectionTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtcollectionfrom').val() + '",DateTo:"' + $('#txtcollectionTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                    $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').prop('disabled', 'disabled');
                    $('#<%=grdStock.ClientID %>').hide();
                }
                else {
                    $('#<%=lblerrmsg.ClientID %>').text('');
                    $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').removeProp('disabled');
                }
            }
        });
    }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Current Blood Stock Status Report</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collection ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCollectionID" runat="server" MaxLength="30"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbCollection" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID="txtCollectionID"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlComponentName" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Bag Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTubeNo" runat="server" MaxLength="20"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3" style="display:none;">
                            <label class="pull-left">
                                Bag Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:DropDownList ID="ddlBagType" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               <asp:CheckBox ID="chkDate" runat="server" ClientIDMode="Static" ToolTip="On Click Check Date Condition" />Coll. Date From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectionfrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectionfrom"
                                TargetControlID="txtcollectionfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Coll. Date To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectionTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectionTo"
                                TargetControlID="txtcollectionTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                            <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre " />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                            </div>
                          </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-14">
                            <asp:Button ID="btnSearch" Text="Search" CssClass="save margin-top-on-btn" runat="server"
                                OnClick="btnSearch_Click" />
                            <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server"
                                OnClick="btnPrint_Click" />
                            <asp:Button ID="btnStockreport" Text="StockReport" CssClass="ItDoseButton" runat="server" OnClick="btnStockreport_Click"/>
                        </div>
                        
                    </div>
        </div>


        <div id="pnlHide" runat="server" visible="false" class="POuter_Box_Inventory">
            <asp:GridView ID="grdStock" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" Width="100%"
                OnPageIndexChanging="grdStock_PageIndexChanging">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Centre Name">
                        <ItemTemplate>
                            <asp:Label ID="lblCentre" runat="server" Text='<%#Eval("CentreName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Collection ID">
                        <ItemTemplate>
                            <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%#Eval("BloodCollection_ID")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Component Name">
                        <ItemTemplate>
                            <asp:Label ID="lblComponentName" runat="server" Text='<%#Eval("ComponentName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bag Type" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblBagType" runat="server" Text='<%#Eval("BagType")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tube No.">
                        <ItemTemplate>
                            <asp:Label ID="lblBBTubeNo" runat="server" Text='<%#Eval("BBTubeNo")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Entry Date">
                        <ItemTemplate>
                            <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Expiry Date">
                        <ItemTemplate>
                            <asp:Label ID="lblExpiryDate" runat="server" Text='<%#Eval("ExpiryDate")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>


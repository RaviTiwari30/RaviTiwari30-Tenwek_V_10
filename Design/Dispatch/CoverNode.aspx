<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CoverNode.aspx.cs" Inherits="Design_Dispatch_CoverNode" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {

            $("#ddlPanelCompany").chosen();
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
                        $("#lblMsg").text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $("#lblMsg").text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var headerChk = $(".chkHeader input");
            var itemChk = $(".chkItem input");
            headerChk.click(function () {
                itemChk.each(function () {
                    this.checked = headerChk[0].checked;
                })
                $("#<%=gvItems.ClientID %> tr").each(function () {
                    if (!this.rowIndex)
                        return;
                    if ($.trim($(this).closest("tr").find("span[id*='lblBillNo']").text()).length == 0)
                        $(this).closest("tr").find("[id*='chkSelect']").removeAttr("checked");
                });
            });
            itemChk.each(function () {
                $(this).click(function () {
                    if (this.checked == false) { headerChk[0].checked = false; }
                })
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Cover Note</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Bill Date From
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucFromDate" TabIndex="1" runat="server" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Bill Date To
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ucToDate" TabIndex="2" runat="server" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Panel
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPanelCompany" runat="server" ClientIDMode="Static" TabIndex="9" ToolTip="Select Panel" Width="240px"></asp:DropDownList>
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
                    <asp:TextBox ID="txtMRNo" TabIndex="3" runat="server" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                        <asp:ListItem Selected="True" Value="OPD">OPD</asp:ListItem>
                        <asp:ListItem Value="EMG">EMG</asp:ListItem>
                        <asp:ListItem Value="IPD">IPD</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" CssClass="ItDoseButton" OnClick="btnSearch_Click" ClientIDMode="Static" Text="Search" runat="server" />
        </div>
        <div runat="server" id="divPatientDetail" visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Patient List </div>
                <div runat="server" style="text-align: center; max-height: 200px; overflow: scroll;">
                    <asp:GridView ID="grdPatientList" runat="server" CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="False" OnRowCommand="grdPatientList_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="View">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgView" runat="server" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("PatientDetail") %>' CommandName="AView" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblPType" runat="server" Text='<%# Eval("PType") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MR No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD/EMG No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblIPDNo" runat="server" Text='<%# Eval("IPD_NO") %>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Cover Note No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblCovernoteNO" runat="server" Text='<%# Eval("CoverNote") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientName" runat="server" Text='<%# Eval("PatientName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Company">
                                <ItemTemplate>
                                    <asp:Label ID="lblCompany" runat="server" Text='<%# Eval("Company") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CardNo">
                                <ItemTemplate>
                                    <asp:Label ID="lblCardNo" runat="server" Text='<%# Eval("CardNo") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Card Holder Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblCardHolderName" runat="server" Text='<%# Eval("CardHolderName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>

                </div>
            </div>
        </div>
        <div runat="server" id="divShow" visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Patient Deatalis </div>
                <div id="Div7" runat="server" style="text-align: center; max-height: 280px; overflow: scroll;">
                    <asp:GridView ID="gvItems" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="150%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <HeaderTemplate>
                                    <asp:CheckBox runat="server" ID="chkSelectAll" Checked="true" CssClass="chkHeader" Text="All" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" CssClass="chkItem" Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>' runat="server" Checked='<% # Util.GetBoolean(Eval("IsCheck"))%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MR No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="100px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientName" runat="server" Text='<%# Eval("PatientName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Company">
                                <ItemTemplate>
                                    <asp:Label ID="lblCompany" runat="server" Text='<%# Eval("Company") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Policy No">
                                <ItemTemplate>
                                    <asp:Label ID="lblPolicy" runat="server" Text='<%# Eval("CardNo") %>' Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>' ></asp:Label>
                                    <asp:TextBox ID="txtPolicy" runat="server" Text='<%# Eval("PolicyNo") %>' Visible="false"></asp:TextBox>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="60px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CardNo">
                                <ItemTemplate>
                                    <asp:Label ID="lblCardNo" runat="server" Text='<%# Eval("CardNo") %>' Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>' ></asp:Label>
                                    <asp:TextBox ID="txtCardno" runat="server" Text='<%# Eval("CardNo") %>' Visible="false" ></asp:TextBox>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="60px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="C.H.Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblCardHolderName" runat="server" Text='<%# Eval("CardHolderName") %>' Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>' ></asp:Label>
                                    <asp:TextBox ID="txtCardHolderName" runat="server" Text='<%# Eval("CardHolderName") %>' Visible="false" ></asp:TextBox>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Other Details">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtOtherDetails" runat="server" ClientIDMode="Static" MaxLength="200" Text='<%# Eval("OtherDetails") %>' Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>' ></asp:TextBox>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="CoverNoteNo.">
                                <ItemTemplate>
                                    <asp:Label ID="lblCoverNoteBillWise" runat="server" Text='<%# Eval("CoverNoteNo") %>' ClientIDMode="Static"  Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>' ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="BillNo.">
                                <ItemTemplate>
                                    <asp:Label ID="lblBillNo" runat="server" Text='<%# Eval("BillNo") %>' ClientIDMode="Static"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Panel Payable">
                                <ItemTemplate>
                                    <asp:Label ID="lblPanelPayable" runat="server" Text='<%# Eval("PanelPayable") %>' Visible='<% # Util.GetBoolean(Eval("IsCheck"))%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Description">
                                <ItemTemplate>
                                    <asp:Label ID="lblDescription" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="200px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ItemCode">
                                <ItemTemplate>
                                    <asp:Label ID="lblItemCode" runat="server" Text='<%# Eval("ItemCode") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="60px" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amount">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("Amount") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="60px" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblLedgerTransactionNo" runat="server" Text='<%# Eval("LedgerTransactionNo") %>'></asp:Label>
                                    <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                                    <asp:Label ID="lblNetAmount" runat="server" Text='<%# Eval("NetAmount") %>'></asp:Label>
                                    <asp:Label ID="lbldiscAmt" runat="server" Text='<%# Eval("discAmt") %>'></asp:Label>
                                    <asp:Label ID="lblDiscOnTotal" runat="server" Text='<%# Eval("DiscountOnTotal") %>'></asp:Label>
                                    <asp:Label ID="lblPaidAmt" runat="server" Text='<%# Eval("PaidAmt") %>'></asp:Label>
                                    <asp:Label ID="lblPolicyNo" runat="server" Text='<%# Eval("PolicyNo") %>'></asp:Label>
                                    <asp:Label ID="lblPanelID" runat="server" Text='<%# Eval("PanelID") %>'></asp:Label>
                                    <asp:Label ID="lblBillDate" runat="server" Text='<%# Eval("BillDate") %>'></asp:Label>
                                    <asp:Label ID="lblGrossAmt" runat="server" Text='<%# Eval("GrossAmount") %>'></asp:Label>
                                    <asp:Label ID="lblBillPType" runat="server" Text='<%# Eval("PType") %>'></asp:Label>
                                     <asp:Label ID="lblCoverNoteID" runat="server" Text='<%# Eval("CoverNoteID") %>'></asp:Label>

                                    
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>

                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Label ID="lblCoverNote" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="lblTotalAmount" runat="server" CssClass="ItDoseLblError" Font-Size="Medium"></asp:Label>
                <br />
                <asp:CheckBox ID="chkIsPrint" runat="server" Text="Print" Visible="false" />
                <asp:Button ID="btnSave" TabIndex="16" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return validateGenerate();" Text="Save" Visible="false" runat="server" />
            </div>
        </div>
    </div>
</asp:Content>

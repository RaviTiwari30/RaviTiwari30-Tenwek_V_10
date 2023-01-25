<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodRequest.aspx.cs" Inherits="Design_BloodBank_BloodRequest" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                // if the key pressed is the escape key, dismiss the dialog
                $find('mpeReject').hide();
            }
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtfromdate').change(function () {
                ChkDate();
            });
            $('#txtdateTo').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromdate').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdSearchList.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });
        }

    </script>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=grdRequestList.ClientID %>").find("input[id$=chkYes2]").each(function () {//commented
                this.onclick = function () {
                    if (this.checked) {
                        var j = 0;
                        var PendingQty = Number($("[id*=lblQtypending]").text());
                        a = $("#<%=grdRequestList.ClientID %>").find("input[id$=chkYes]");
                        for (i = 0; i < a.length; i++) {
                            if (a[i].type == "checkbox") {
                                if (a[i].checked) {
                                    j = Number(j) + 1;
                                }
                            }
                        }
                        if (j > 0) {
                            if (j > PendingQty) {
                                modelAlert("Selected Qty is Greater than Pending Qty");
                                this.checked = false;
                            }
                            else {
                                this.parentNode.parentNode.style.backgroundColor = 'cyan';
                                //    document.getElementById('<%=btnShowStock.ClientID %>').disabled = false;
                                //    document.getElementById('<%=btnDispatch.ClientID %>').disabled = false;
                            }
                        }
                    }
                    else {
                        this.parentNode.parentNode.style.backgroundColor = 'transparent';
                        //document.getElementById('<%=btnShowStock.ClientID %>').disabled = true;
                        //document.getElementById('<%=btnDispatch.ClientID %>').disabled = true;
                    }
                };
            });

            /******************************************************************/
            $("#<%=grdRequestList.ClientID %>").find("input[id$=chkYes]").each(function () {
                this.onclick = function () {
                    if (this.checked) {
                        this.parentNode.parentNode.style.backgroundColor = 'cyan';
                        setGoal();
                    }
                    else {
                        this.parentNode.parentNode.style.backgroundColor = 'transparent';
                        setGoal();
                    }
                };
            });
        });
        function clearAllField() {
            $(':text, textarea').val('');
        }

        function setGoal() {
            var j = 0;
            a = document.getElementsByTagName("input");
            for (i = 0; i < a.length; i++) {
                if (a[i].type == "checkbox") {


                    if (a[i].checked) {
                        j = Number(j) + 1;
                    }

                }
            }
            if (j > 0) {
                document.getElementById('<%=btnShowStock.ClientID %>').disabled = false;
                document.getElementById('<%=btnDispatch.ClientID %>').disabled = false;
            }
            else {
                document.getElementById('<%=btnShowStock.ClientID %>').disabled = true;
                document.getElementById('<%=btnDispatch.ClientID %>').disabled = true;

            }

        }


        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnShowStock', '');

        }
        function RestrictDoubleEntry1(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnDispatch', '');

        }
        function RestrictDoubleEntry2(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnCrossMatch', '');

        }
        function RestrictDoubleEntry3(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnReserve', '');

        }

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Blood Issue</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;

            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server" TabIndex="1" MaxLength="50" ToolTip="Enter Patient Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRegNo" TabIndex="2" MaxLength="20" ToolTip="Enter UHID" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" TabIndex="3" MaxLength="20" ToolTip="Enter IPD No." runat="server" />
                            <cc1:FilteredTextBoxExtender ID="ftbIPDNo" runat="server" TargetControlID="txtIPDNo"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbType" runat="server" TabIndex="4" RepeatDirection="Horizontal">

                                <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="EMG" Value="EMG"></asp:ListItem>
                                <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtfromdate" runat="server" TabIndex="5" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calfromdate" TargetControlID="txtfromdate" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="txtdateTo" runat="server" TabIndex="6" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calTodate" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-9">
                    <button type="button" style=" display:none; width : 30px; height: 30px; float: left; margin-left: 5px; background-color: #f38f78" class="circle"></button>
                    <b style="display:none;float: left; margin-top: 5px; margin-left: 5px">Reserved</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #69e6b0" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Issued</b>
                </div>
                <div class="col-md-15" style="text-align: left;">

                    <asp:Label ID="lblLedgerTransactionNo" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblTransaction_ID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblTypeOfTnx" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblComponent1" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblPatientId" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblStockID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblLedgerTnxID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblStockID4" runat="server" Visible="false"></asp:Label>
                   <asp:Button ID="btnSearch" runat="server" TabIndex="7" ToolTip="Click To Search" CssClass="save margin-top-on-btn" Text="Search" OnClick="btnSearch_Click" />&nbsp;
                   <asp:Button ID="btnReport" runat="server" TabIndex="7" ToolTip="Click For Report" CssClass="save margin-top-on-btn" Text="Report" OnClick="btnReport_Click" />&nbsp;

                </div>
            </div>
        </div>
        <asp:Panel ID="pnlSearch" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto; height: 200px">
                <asp:GridView ID="grdSearchList" TabIndex="22" runat="Server" CssClass="GridViewStyle"
                    OnRowCommand="grdSearchList_RowCommand" AutoGenerateColumns="False" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientId1" runat="server" Text='<%# Util.GetString(Eval("PatientId"))%>' />
                                <asp:Label ID="lblTransaction_ID1" runat="server" Text='<%# Eval("TransactionID")%>'
                                    Visible="false" />
                                <asp:Label ID="lblLedgerTransactionNo1" runat="server" Text='<%# Eval("LedgerTransactionNo")%>'
                                    Visible="false" />
                                <asp:Label ID="lblStockID3" runat="server" Text='<%#Eval("BloodStockID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTransaction_ID3" runat="server" Text='<%# Util.GetString(Eval("TransNo")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("PatientName")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tnx. Type">
                            <ItemTemplate>
                                <asp:Label ID="lblTnxType1" runat="server" Text='<%# Eval("TnxType")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Gross Amt." Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblGrossAmt" runat="server" Text='<%# Eval("GrossAmt")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Net Amt." Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblNetAmt" runat="server" Text='<%# Eval("NetAmt")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Doctor Name" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblDName" runat="server" Text='<%# Eval("DName")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Group">
                            <ItemTemplate>
                                <asp:Label ID="lblBlood" runat="server" Text='<%# Eval("BloodGroup")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ItemName">
                            <ItemTemplate>
                               <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                <asp:Label ID="lbItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity">
                            <ItemTemplate>
                                <asp:Label ID="lblQuantity" runat="server" Text='<%#Eval("Qty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ward Name">
                            <ItemTemplate>
                                <asp:Label ID="lblWName" runat="server" Text='<%# Eval("Name")%>' /> /
                                <asp:Label ID="lblBedNo" runat="server" Text='<%# Eval("Bed_No")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bed No." Visible="false">
                            <ItemTemplate>
                                <%--<asp:Label ID="lblBedNo" runat="server" Text='<%# Eval("Bed_No")%>' />--%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Process">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/view.gif" CommandName="AResult"
                                    CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgreject" runat="server" ImageUrl="../../Images/Delete.gif" CommandName="Reject" 
                                    CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlTran" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto; height: 100px">
                <asp:GridView ID="grdTran" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                    OnRowCommand="grdTran_RowCommand" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName2" runat="server" Text='<%# Eval("ItemName")%>' />
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID")%>' Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity">
                            <ItemTemplate>
                                <asp:Label ID="lblQuantity2" runat="server" Text='<%# Eval("Quantity")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Iscomponent" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblIscomponent" runat="server" Text='<%# Eval("Iscomponent")%>' />
                                <asp:Label ID="lblLedgerTnxID2" runat="server" Text='<%# Eval("LedgerTnxID")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rate">
                            <ItemTemplate>
                                <asp:Label ID="lblRate2" runat="server" Text='<%# Eval("Rate")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Amount">
                            <ItemTemplate>
                                <asp:Label ID="txtAmount2" runat="server" Text='<%# Eval("Amount")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Process">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/view.gif" CommandName="ASelect"
                                    CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgReject" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="Areject"
                                    CommandArgument='<%# Eval("LedgerTransactionNo")+ "#" +Eval("ItemID")%>' CausesValidation="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <table style="display: none">
                    <tr>
                        <td>
                            <asp:Label ID="Label1" runat="server" Text="Reason of transfusion/Diagnosis"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtReason" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlRequest" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto; height: 200px">
                <div style="text-align: left; padding-left: 35px;">

                    <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblInitialcount1" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblItemID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblQtypending" runat="server" Style="display: none"></asp:Label>
                    <asp:Label ID="lblServiceID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblPanelID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblIPDCaseType_Id" runat="server" Visible="false"></asp:Label>

                    <table style="width: 100%;display:none;">
                        <tr>
                            <td style="border: groove;">
                                <asp:Label ID="lblPID" runat="server" Style="font-weight: 700; color: #990000"></asp:Label></td>
                            <td style="border: groove;">
                                <asp:Label ID="lblPIPDNo" runat="server" Style="font-weight: 700; color: #990000"></asp:Label></td>
                            <td style="border: groove;">
                                <asp:Label ID="lblPName" runat="server" Style="font-weight: 700; color: #990000"></asp:Label></td>
                            <td style="border: groove;">
                                <asp:Label ID="lblPBloodGroup" runat="server" Style="font-weight: 700; color: #990000"></asp:Label>
                                <asp:Label ID="lblBloodGroup" runat="server" Visible="false"></asp:Label>
                                <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="ItDoseDropdownbox" Width="65px"></asp:DropDownList>
                                <asp:Button ID="btnUpdateBloodgroup" runat="server" CssClass="ItDoseButton" Width="50" Text="Update" OnClick="btnUpdateBloodgroup_Click" /></td>
                            <td style="border: groove;">
                                <asp:Label ID="lblRequestQty" runat="server" Style="font-weight: 700; color: #990000"></asp:Label></td>
                            <td style="border: groove;">
                                <asp:Label ID="lblComponentName" runat="server" Style="font-weight: 700; color: #990000"></asp:Label></td>
                        </tr>
                    </table>
                </div>
                <asp:GridView ID="grdRequestList" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkYes" runat="server" AutoPostBack="false" OnCheckedChanged="chkYes_OnCheckedChanged" />
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblID1" Text='<%# Eval("id") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblStockId1" Text='<%# Eval("stock_ID") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblServiceRequestID" Text='<%# Eval("ServiceRequestID") %>' Visible="false" runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component Name">
                            <ItemTemplate>
                                <asp:Label ID="lblComponentName" Text='<%# Eval("ComponentName") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type">
                            <ItemTemplate>
                                <asp:Label ID="lblbagtype" Text='<%#Eval("bagtype")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BloodGroup">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodGroup" Text='<%#Eval("BloodGroup")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag No.">
                            <ItemTemplate>
                                <asp:Label ID="lblBBTubeNo" Text='<%#Eval("BBTubeNo")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Collection ID">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodCollection" Text='<%#Eval("BloodCollection_Id")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" Text='<%#Eval("EntryDate")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiry" Text='<%#Eval("ExpiryDate")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Initial Count">
                            <ItemTemplate>
                                <asp:Label ID="lblInitialCount" Text='<%#Eval("InitialCount")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HaveComponent" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblHaveComponent" Text='<%#Eval("HaveComponent")%>' runat="server"></asp:Label>
                                <asp:Label ID="lblcomponentid" Text='<%#Eval("componentid")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Volume" Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtVolume" runat="server" Width="60px" BackColor="#ffffcc" MaxLength="3"></asp:TextBox>
                                ml
                                <cc1:FilteredTextBoxExtender ID="ftbVolume" runat="server" FilterType="Numbers" TargetControlID="txtVolume">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
                <%--<asp:GridView ID="grdRequestList" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="100%" OnRowDataBound="grdRequestList_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CrossMatch">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkYes" runat="server" AutoPostBack="false" OnCheckedChanged="chkYes_OnCheckedChanged" />
                                <asp:Label ID="lblIsCrossMatch" Text='<%# Eval("IsCrossMatch") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblIsUnReserved" Text='<%# Eval("IsUnReserved") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblisCrosschargesapply" Text='<%# Eval("isCrosschargesapply") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblIsCompatiblity" Text='<%# Eval("Compatiblity") %>' Visible="false" runat="server"></asp:Label>
                                
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblID1" Text='<%# Eval("id") %>' Visible="false" runat="server"></asp:Label>
                                <asp:Label ID="lblStockId1" Text='<%# Eval("stock_ID") %>' Visible="false" runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component Name">
                            <ItemTemplate>
                                <asp:Label ID="lblComponentName" Text='<%# Eval("ComponentName") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblbagtype" Text='<%#Eval("bagtype")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BloodGroup">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodGroup" Text='<%#Eval("BloodGroup")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Number">
                            <ItemTemplate>
                                <asp:Label ID="lblBBTubeNo" Text='<%#Eval("BBTubeNo")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Collection ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodCollection" Text='<%#Eval("BloodCollection_Id")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" Text='<%#Eval("EntryDate")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiry" Text='<%#Eval("ExpiryDate")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Initial Count">
                            <ItemTemplate>
                                <asp:Label ID="lblInitialCount" Text='<%#Eval("InitialCount")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Compatible">
                            <ItemTemplate>
                               <asp:DropDownList ID="ddlCompatibility" runat="server" ToolTip="Please Select Compatiblity" CssClass="requiredField">
                                     <asp:ListItem Text="" Value=""></asp:ListItem>
                                     <asp:ListItem Text="Compatible" Value="Compatible"></asp:ListItem>
                                     <asp:ListItem Text="Un-Compatible" Value="UnCompatible"></asp:ListItem>
                                     <asp:ListItem Text="As On Compatible" Value="AsOnCompatible"></asp:ListItem>
                               </asp:DropDownList>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HaveComponent" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblHaveComponent" Text='<%#Eval("HaveComponent")%>' runat="server"></asp:Label>
                                <asp:Label ID="lblcomponentid" Text='<%#Eval("componentid")%>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Volume" Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtVolume" runat="server" Width="60px" BackColor="#ffffcc" MaxLength="3"></asp:TextBox>
                                ml
                                <cc1:FilteredTextBoxExtender ID="ftbVolume" runat="server" FilterType="Numbers" TargetControlID="txtVolume">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>--%>
                &nbsp;
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnCrossMatch" runat="server" CssClass="save margin-top-on-btn" Text="CrossMatch"
                    OnClick="btnCrossMatch_Click" OnClientClick="RestrictDoubleEntry2(this);" Enabled="false" Visible="false" />&nbsp;
                <asp:Button ID="btnShowStock" runat="server" CssClass="save margin-top-on-btn" Text="Issue"
                    OnClick="btnShowStock_Click" OnClientClick="RestrictDoubleEntry(this);" Enabled="false" />&nbsp;
                <asp:Button ID="btnDispatch" runat="server" CssClass="save margin-top-on-btn" Text="Dispatch"
                    OnClick="btnDispatch_Click" OnClientClick="RestrictDoubleEntry1(this);" Style="display: none" />&nbsp;
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlreject" runat="server" Style="display: none" Width="620px" CssClass="pnlVendorItemsFilter">
            <div class="content">
                <asp:GridView ID="grdreject" Width="580px" runat="server" CssClass="GridViewStyle"
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="240px" />
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblLedgerTnxID" runat="server" Text='<%#Eval("LedgerTnxID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblRtnxType" runat="server" Text='<%#Eval("TYPE") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Requested Qty.">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblRequestedQty" runat="server" Text='<%#Eval("RequestedQty") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Pending Qty.">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblPendingQty" runat="server" Text='<%#Eval("PendingQty") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject Qty.">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:TextBox ID="lblRejectQty" runat="server" MaxLength="8" Text='<%#Eval("PendingQty") %>'></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbRejectQty" runat="server" TargetControlID="lblRejectQty"
                                    ValidChars=".0123456789">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <br />
            <div style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="save margin-top-on-btn" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="save margin-top-on-btn" />
            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
        </div>
        <cc1:ModalPopupExtender ID="mpeReject" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel" PopupControlID="pnlreject"
            BehaviorID="mpeReject" TargetControlID="btnHidden">
        </cc1:ModalPopupExtender>

        <asp:Panel ID="pnlIssue" runat="server" Style="display: none" Width="620px" CssClass="pnlVendorItemsFilter">
            <div class="Purchaseheader">Issue Reserved Blood Stock</div>
            <div class="content">
                <asp:GridView ID="grdIssue" Width="600px" runat="server" CssClass="GridViewStyle" ClientIDMode="Static"  OnRowDataBound="grdIssue_RowDataBound" OnRowCommand="grdIssue_RowCommand"
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                                <asp:CheckBox ID="chkIssue" runat="server" AutoPostBack="false" />
                            </ItemTemplate>

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="240px" />
                            <ItemTemplate>
                                <asp:Label ID="lblCItemName" runat="server" Text='<%#Eval("ComponentName") %>'></asp:Label>
                                <asp:Label ID="lblCItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCComponentID" runat="server" Text='<%#Eval("ComponentID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCServiceReqID" runat="server" Text='<%#Eval("ServiceRequestID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsIssue" runat="server" Text='<%#Eval("IsIssue") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="StockId">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblCStockID" runat="server" Text='<%#Eval("BloodStockID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag No.">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblCBatchNo" runat="server" Text='<%#Eval("BBTubeNo") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Print">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <ItemTemplate>
                                  <asp:ImageButton ID="imgPrintBag" runat="server" ImageUrl="~/Images/print.gif" CommandName="imgPrint"
                                    CommandArgument='<%# Eval("BloodStockID")+ "#" +Eval("Type")+ "#" +Eval("TransactionID")%>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <br />
            <div style="text-align: center;">
                <asp:Button ID="btnCIssue" runat="server" Text="Issue" CssClass="save margin-top-on-btn" OnClientClick="onIssueBloodItems(event,this)" OnClick="btnCIssue_Click" />
                <asp:Button ID="btnUnReserve" runat="server" Text="Un Reserve" CssClass="save margin-top-on-btn" OnClientClick="onUnReserveBloodItems(event,this)" OnClick="btnUnReserve_Click" />
                <asp:Button ID="btnCCancel" runat="server" Text="Cancel" CssClass="save margin-top-on-btn" />
            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnCHidden" runat="server" CssClass="ItDoseButton" />
        </div>
        <cc1:ModalPopupExtender ID="mpeIssue" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnCCancel" PopupControlID="pnlIssue"
            BehaviorID="mpeIssue" TargetControlID="btnHidden">
        </cc1:ModalPopupExtender>
    </div>





    <script type="text/javascript">

        
        var onIssueBloodItems = function (e,el) {
            e.preventDefault();

            var totalSelected = $('#grdIssue').find('input[type=checkbox]:checked');

            if (totalSelected.length < 1)
                alert('Please Select Stock.')

            else {
                $(el).attr('disabled', true);
                __doPostBack('ctl00$ContentPlaceHolder1$btnCIssue', null);
            }
        }




        var onUnReserveBloodItems = function (e, el) {
            e.preventDefault();

            var totalSelected = $('#grdIssue').find('input[type=checkbox]:checked');

            if (totalSelected.length < 1)
                alert('Please Select Stock.')

            else {
                $(el).attr('disabled', true);
                __doPostBack('ctl00$ContentPlaceHolder1$btnUnReserve', null);
            }
        }




    </script>

</asp:Content>

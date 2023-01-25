<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReceiptBill.aspx.cs" Inherits="Design_IPD_ReceiptBill" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>IPD Advance/Refund</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" Style="display: none"></asp:TextBox>
            <asp:Label ID="lblIPDAdvanceRefund" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div style="display:none" class="row">
                        <div class="col-md-7"></div>
                        <div class="col-md-8">
                            <span style="font-size: 8pt; color: #54a0c0; font-family: Verdana">
                                <asp:RadioButton ID="rdbAdmitted" runat="server" Checked="True" CssClass="ItDoseLabelSp"
                                    Font-Bold="True" Font-Names="Verdana" Font-Size="Small" GroupName="Same" Text="Admitted" />
                                &nbsp;
                            <asp:RadioButton ID="rdbDischarged" runat="server" Font-Bold="True" Font-Names="Verdana"
                                Font-Size="Small" GroupName="Same" Text="Discharged" CssClass="ItDoseLabelSp" /></span>
                        </div>
                        <div class="col-md-7"></div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransactionId" runat="server" AutoCompleteType="Disabled" TabIndex="1" ToolTip="Enter IPD No." MaxLength="10"></asp:TextBox>
                            
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" ToolTip="Enter Patient Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled" 
                                TabIndex="3" ToolTip="Enter Registration No."></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-11">

                    <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-avilable"></button>
                             <b style="margin-top:5px;margin-left:5px;float:left">Admitted</b> &nbsp;
                    <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-warning"></button>
                             <b style="margin-top:5px;margin-left:5px;float:left">Discharged</b> 
                </div>
                <div style="text-align: center;" class="col-md-2">
                    <asp:Button ID="btnView" runat="server" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnView_Click" TabIndex="4" Text="Search"  ToolTip="Click To View Patient Details" />
                </div>
                <div class="col-md-11">
                    
                </div>                
            </div>

              

            
        </div>
        <div id="grdhide">
            <asp:Panel ID="pnlRecord" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Patient Record
                    </div>
                    <div style="padding: 3px; overflow: auto; max-height: 100px; text-align: center">
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Width="100%" OnRowDataBound="GridView1_RowDataBound" >
                            <Columns>
                                <asp:BoundField DataField="PatientID" HeaderText="UHID">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                            
                                <asp:BoundField DataField ="IPDNo" HeaderText="IPD No">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PName" HeaderText="Name">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Company_Name" HeaderText="Panel">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RoomNo" HeaderText="Room No.">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:BoundField>
                           
                                  <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransactionID")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPanelID" runat="server" Text='<%# Eval("PanelID")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAddress" runat="server" Text='<%# Eval("Address") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRelation" runat="server" Text='<%# Eval("Relation") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRelationName" runat="server" Text='<%# Eval("RelationName") %>'></asp:Label>
                                        <asp:Label ID="lblStatus"  style="display:none" runat="server" Text='<%# Eval("status") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ButtonType="Image" HeaderText="Select" SelectImageUrl="~/Images/Post.gif"
                                    ShowSelectButton="True">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:CommandField>
                                
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
        </div>
        <div id="gdhide">
            <asp:Panel ID="pnlDetails" runat="server" Visible="false">
                <asp:Label ID="lblIPDAdvance" runat="server" Style="display: none"></asp:Label>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Receipt Details
                    </div>
                    <asp:Panel ID="Panel1" runat="server">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Patient Name</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">IPD No. </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblTransactionNo" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                                        <asp:Label ID="lblTransactionNo1" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">UHID</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp pull-left" ClientIDMode="Static"></asp:Label>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Room No.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblRoomNo" runat="server" CssClass="ItDoseLabelSp pull-left "></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Doctor</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblDoctorName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Date of Admission</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblAdmissionDate" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Address</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPaddress" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <asp:Label ID="lblPRelation" CssClass="pull-left" runat="server"></asp:Label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPRelationName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Net Bill Amt. </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                          <asp:Label ID="lblTotalBill_Amt" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Panel</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseLabelSp pull-left "></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Panel Appr. Amt.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPanelApp_Amt" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                     <div class="col-md-3">
                                        <label class="pull-left">Patient Paid Amt.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                         <asp:Label ID="lblPaidAmt" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>  
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Admission Status</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                              <asp:Label ID="lblPatientAdmissionStatus" Font-Bold="true" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>                                
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Round Off </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                        <asp:Label ID="lblIsRefund" runat="server" Style="display: none"></asp:Label>
                                    </div>

                                   <div class="col-md-3">
                                        <label class="pull-left">Pat. Payable Amt.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPatientAdvance" runat="server" ClientIDMode="Static" style="display:none" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                          <asp:Label ID="lblNonPayableAmt" runat="server" CssClass="ItDoseLabelSp pull-left" Font-Bold="true" Font-Underline="true" ForeColor="Red"></asp:Label>
                                    </div>

                                </div>

                                 <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Panel Payable </label>
                                        <b class="pull-right">:</b>
                                    </div>

                                     <div class="col-md-5">
                                        <asp:Label ID="lblPanelPayableAmount" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>

                                     <div class="col-md-3">
                                        <label class="pull-left">Panel Paid  </label>
                                        <b class="pull-right">:</b>
                                    </div>

                                     <div class="col-md-5">
                                        <asp:Label ID="lblPanelPaidAmount" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>

                                      <div class="col-md-3">
                                        <label class="pull-left">Total Paid Amt.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                      <asp:Label ID="lblTotalPaidAmt" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>

                                 </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Bill Account </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div id="divHospitalLedger" class="col-md-13">
                                        <asp:RadioButtonList ID="chkHospLedger" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"></asp:RadioButtonList>
                                        <asp:CheckBox ID="chkRefund" runat="server" Text="Refund" class="clRefund" Style="display: none" />
                                    </div>
                                    
                                    <div class="col-md-3">
                                        <label class="pull-left">Amount </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-3">
                                        <asp:TextBox ID="txtReceiveAmount" AutoComplete="off"  decimalplace="4"  onlynumber="14" onkeyup="onAmountChange(this.value)" CssClass="ItDoseTextinputNum" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>

                    </asp:Panel>
                </div>
                <div class="POuter_Box_Inventory">
                    <div id="divPaymentUserControl" runat="server"></div>
                    <div class="row" style="margin: 0px">
                        <div class="col-md-15"></div>
                        <div class="col-md-9">
                            <div class="row" style="margin-top: 0px">
                                <div class="col-md-7">
                                    <label class="pull-left">Received From  </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-17">
                                    <input type="text" id="txtPaymentReceivedFrom"  autocomplete="off" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="divSave"  class="POuter_Box_Inventory" style="text-align: center;">
                    <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" onclick="save(this)" />
                </div>
            </asp:Panel>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Patient Advance Detail
            </div>
            <div id="hide">
                <asp:GridView ID="grdReceipt" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="Receipt No.">
                            <ItemTemplate>
                                <asp:Label ID="lblReceipt" runat="server" Text='<%# Eval("ReceiptNo") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Payment Mode">
                            <ItemTemplate>
                                <asp:Label ID="lblPaymentMode" runat="server" Text='<%# Eval("PaymentMode") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Amount Paid">
                            <ItemTemplate>
                                <asp:Label ID="lblAmountPaid" runat="server" Text='<%# Eval("AmountPaid") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%# Eval("Time") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Receiver">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%# Eval("Receiver") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="170px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="PayMode">
                        <ItemTemplate>
                            <asp:Label ID="lblPayMode" runat="server" Text='<%# Eval("IsCheque_Draft") %>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%# Eval("Type") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        var onAmountChange = function (value) {
            // alert(value);
            if (value > 0) {
                var amount = String.isNullOrEmpty(value) ? 0 : value;
                $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                var isrefund = $.trim($('#<%=lblIsRefund.ClientID%>').text()) == '1' ? true : false;
                var panelID = '<%=Util.GetInt(ViewState["PanelID"])%>';
                var refund = { status: isrefund, refundPaymentMode: 1 };
                var patientAdvance = Number($.trim($("#lblPatientAdvance").text()));
                $addBillAmount({
                    panelId: panelID,
                    billAmount: amount,
                    minimumPayableAmount: amount,
                    disCountAmount: 0,
                    isReceipt: true,
                    disableDiscount: true,
                    disableCredit: true,
                    patientAdvanceAmount: patientAdvance,
                    minimumPayableAmount: amount,
                    refund: refund
                }, function () { });
            }
        }

        var getIPDAdvanceRefundDetails = function (callback) {
            var data = {
                amount: $('#<%=txtReceiveAmount.ClientID%>').val().trim(),
                hashCode: $('#<%=txtHash.ClientID%>').val(),
                IsRefund: $.trim($('#<%=lblIsRefund.ClientID%>').text()),
                transactionNo: $.trim($('#<%=lblTransactionNo.ClientID%>').text()),
                isAdmitted: $.trim($('#<%=rdbAdmitted.ClientID %>').prop('checked')),
                hospLedger: $.trim($('#divHospitalLedger').find('input[type=radio]:checked').val()),
                patientID: $.trim($('#<%=lblPatientID.ClientID%>').text()),
                roomNo: $.trim($('#<%=lblRoomNo.ClientID%>').text()),
                doctorName: $.trim($('#<%=lblDoctorName.ClientID%>').text()),
                patientName: $.trim($('#<%=lblPatientName.ClientID%>').text()),
                panelName: $.trim($('#<%=lblPanelComp.ClientID%>').text()),
                paymentReceivedFrom: $.trim($('#txtPaymentReceivedFrom').val()),
                panelID: '<%=Util.GetInt(ViewState["PanelID"])%>'
            }
            callback(data);
        }

        var getIPDAdvanceRefundPaymentDetails = function (callback) {
            getIPDAdvanceRefundDetails(function (advanceRefundDetails) {
                $getPaymentDetails(function (payment) {
                    advanceRefundDetails.totalPaidAmount = payment.adjustment;
                    advanceRefundDetails.paymentRemarks = payment.paymentRemarks;
                    advanceRefundDetails.paymentDetail = [];
                    $(payment.paymentDetails).each(function () {
                        advanceRefundDetails.paymentDetail.push({
                            PaymentMode: this.PaymentMode,
                            PaymentModeID: this.PaymentModeID,
                            S_Amount: this.S_Amount,
                            S_Currency: this.S_Currency,
                            S_CountryID: this.S_CountryID,
                            BankName: this.BankName,
                            RefNo: this.RefNo,
                            BaceCurrency: this.BaceCurrency,
                            C_Factor: this.C_Factor,
                            Amount: this.Amount,
                            S_Notation: this.S_Notation,
                            PaymentRemarks: this.paymentRemarks,
                            swipeMachine:this.swipeMachine,
                            currencyRoundOff: payment.currencyRoundOff / payment.paymentDetails.length
                        });
                    });
                    console.log(advanceRefundDetails);
                    if (advanceRefundDetails.paymentDetail.length < 1) {
                        modelAlert('Please Select Atleast One Payment Mode');
                        return false;
                    }
                    //if (String.isNullOrEmpty(advanceRefundDetails.paymentReceivedFrom)) {
                    //    modelAlert('Please Enter Payment Received From', function () {
                    //        $('#txtPaymentReceivedFrom').focus();
                    //    });
                    //    return false;
                    //}
                    if(advanceRefundDetails.IsRefund=='1'){
                        modelConfirmation('Are You Sure To Refund ?', '<b>Amount : ' + advanceRefundDetails.totalPaidAmount + '</b>', 'Yes Refund', 'No', function (response) {
                            if(response)
                                callback(advanceRefundDetails);
                        });
                    }
                    else
                        callback(advanceRefundDetails);
                });
            });
        }


        var save = function (btnSave) {
            var isrefund = $.trim($('#<%=lblIsRefund.ClientID%>').text()) == '1' ? true : false;
            if (isrefund)
            {
                //if ($('#ddlControlApprovedBY').val() == '0')
                //{
                //    modelAlert('Please select Approved By');
                //    return;
                //}
                if ($('#txtControlRemarks').val() == '')
                {
                    modelAlert('Please Enter Remarks');
                    return;
                }
            }
            if ($('#txtControlRemarks').val() == '') {
                modelAlert('Please Enter Remarks');
                return;
            }
            getIPDAdvanceRefundPaymentDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('ReceiptBill.aspx/Save', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            window.open($responseData.responseURL);
                            window.location.href = 'ReceiptBill.aspx';
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }

        $(function () {
            shortcut.add("Alt+S", function () {
                var btnSave = $('#btnSave');
                if (!String.isNullOrEmpty(btnSave)) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        save(btnSave);
                    }
                }
            }, addShortCutOptions);

            

            $('#<%=chkHospLedger.ClientID %>').change(function () {
                var id = $(this).find('input[type=radio]:checked').attr('id');
                if ($("label[for=" + id + "]").text() == "ADVANCE-COL") {
                    $('#<%=chkRefund.ClientID %>').prop("checked", false);
                    $('#<%=lblIsRefund.ClientID%>').text("0");
                }
                else if ($("label[for=" + id + "]").text() == "IPD-REFUND") {
                    $('#<%=chkRefund.ClientID %>').prop("checked", true);
                    $('#<%=lblIsRefund.ClientID%>').text("1");
                }
            });
                

        });

        function chkHospLedgerType() {
            $('#chkHospLedger input').each(function () {
                var id = $(this).attr("id");
                if ($("label[for=" + id + "]").text() != "IPD-REFUND" && $("label[for=" + id + "]").text() != "ADVANCE-COL") {
                    $(this).prop("disabled", true)
                }

            });
        }
       
        $(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13 && $(this).length > 0)
                    $('#btnView').click();
            });
        });
    </script>

    <style type="text/css">
        #divPaymentControlParent {
            border: none;
        }
    </style>

</asp:Content>

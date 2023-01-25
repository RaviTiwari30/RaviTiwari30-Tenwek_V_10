<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Emergency_Cancel_Release_Discharge.aspx.cs" Inherits="Design_Emergency_Emergency_Cancel_Release_Discharge" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        function search() {
            if (($.trim($("#txtPatientId").val()) == "") && ($.trim($("#txtEMGNo").val()) == "") && ($.trim($("#txtPName").val()) == "")) {
                $("#lblMsg").text('Please Enter Any One Search Criteria');
                $("#txtPatientId").focus();
                return false;
            }
        }
        function validate() {
            if ($("#<%=txtCancelReason.ClientID %>").val() == "") {
                $("#<%=lblmsgpopup.ClientID %>").text('Please Enter Cancel Reason');
                $("#<%=txtCancelReason.ClientID %>").focus();
                return false;
            }
            //   document.getElementById('<%=btnCancel.ClientID%>').disabled = true;            
        }

        function hideGrid() {
            $("#grdPatientDetail tr").remove();
            $("#<%=btnCancel.ClientID %>,.hide").hide();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpDetail")) {
                    $find("mpDetail").hide();

                }
            }

        }
        function closeDetail() {
            if ($find("mpDetail")) {
                $find("mpDetail").hide();
                $("#<%=txtCancelReason.ClientID %>").val('');
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Emergency Release/Discharge Cancel</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria  &nbsp;
            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        UHID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPatientId" runat="server" ToolTip="Enter UHID" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        EMG No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtEMGNo" runat="server" ToolTip="Enter Patient IPD No." TabIndex="2" ClientIDMode="Static" MaxLength="20"></asp:TextBox>
                   
                </div>
                <div class="col-md-3" style="display:none;">
                    <label class="pull-left">
                        Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display:none;">
                    <asp:TextBox ID="txtPName" runat="server" ToolTip="Enter Patient Name" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div> 
          
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                CssClass="ItDoseButton" ToolTip="Click to Search" OnClientClick="return search()" />
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false" Style="text-align: center">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Result Details &nbsp;
                </div>
                <asp:GridView ID="grdPatientDetail" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="grdPatientDetail_SelectedIndexChanged"
                    CssClass="GridViewStyle" ClientIDMode="Static" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No." Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblReleaseStatus" Visible="false" Text='<%#Eval("ReleaseStatus") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblPatientName" Visible="false" Text='<%#Eval("NAME") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblDischargeStatus" Visible="false" Text='<%#Eval("DischargeStatus") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblTransactionID" Visible="false" Text='<%#Eval("TransactionID") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblEMGNo" Visible="false" Text='<%#Eval("EmergencyNo") %>' runat="server"></asp:Label>
                               </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="PatientID" HeaderText="UHID">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="EmergencyNo" HeaderText="EmergencyNo">
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Name" HeaderText="Patient Name">
                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="AgeSex" HeaderText="Age/Sex">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="DOA" HeaderText="DOA">
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="DischargeStatus" HeaderText="Discharged">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="DischargeDatetime" HeaderText="Discharge Date/Time">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="DischargedBy" HeaderText="Discharged By">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="ReleaseStatus" HeaderText="Released">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="ReleasedBy" HeaderText="Released By">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="ReleasedDateTime" HeaderText="Released Date/Time">
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                          <asp:TemplateField HeaderText="UHID" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" Text='<%#Util.GetString(Eval("PatientID")) %>'
                                    runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        
                        <asp:BoundField DataField="DOB" HeaderText="DOB" Visible="false">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:CommandField HeaderText="Select" ButtonType="Image" ShowSelectButton="true"
                            SelectImageUrl="~/Images/Post.gif">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </asp:Panel>

    </div>
    <cc1:ModalPopupExtender ID="mpDetail" runat="server" CancelControlID="btnClose"
        TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDetail"
        X="160" Y="120" BehaviorID="mpDetail">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 947px">
        <div class="Purchaseheader">

            Cancel
            <em><span style="font-size: 7.5pt;float:right" class="shat">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" alt="" onclick="closeDetail()" />
                to close</span></em>
 
        </div>

        <asp:Label ID="lblRoomID" runat="server" Visible="false"></asp:Label>
        <asp:Label ID="lblPatientIPDProfileID" runat="server" Visible="false"></asp:Label>
                <table style="width: 100%;margin:5px;padding:5px; border-collapse: collapse">
            <tr style="margin:5px;padding:5px;">
                <td style="text-align: center" colspan="6">
                    <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr style="margin:5px;padding:5px;">
                <td style="text-align: center; " >EMG No. :&nbsp;
                </td>
                <td style="text-align: center; ">
                    <asp:Label ID="lblEMGNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label> &nbsp;&nbsp;&nbsp;
 
                </td>
                
                <td style="text-align: center; ">UHID :&nbsp;
                </td>
                
                <td style="text-align: center;">
                    <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp" ></asp:Label>
                   
                </td>
                <td style="text-align: center;">Patient Name :&nbsp;
                </td>
                <td style="text-align: center; ">
                    <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
             <tr style="margin:5px;padding:5px;width:100%;">
                <td style=""  colspan="2" class="ItDoseLabel">&nbsp;</td>
                
                <td style=""  colspan="2" >
                    <asp:RadioButton ID="rdbRelease" runat="server"  GroupName="a"
                        Text="Released" />
                    </td>
                <td style=""  colspan="2" >
                    <asp:RadioButton ID="rdbDischarge" runat="server"  GroupName="a" 
                        Text="Discharged" />
                    </td>
            </tr>
           
            <tr  style="margin:5px;padding:5px;">
                
                
                <td style="text-align: center; "> &nbsp;
                </td>
                <td style="text-align: center;">Release Status :&nbsp;
                </td>
                
                <td style="text-align: center; "> 
                     <asp:Label ID="lblReleaseStatus" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                
                    <asp:Label ID="lblTransactionID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                   
                </td>
                
                <td style="text-align: center; ">Discharge Status :&nbsp;
                </td>
                <td style="text-align: center; ">
                     <asp:Label ID="lblDischargeStatus" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                
                </td>
                <td style="text-align: center;">
                    </td>
            </tr>
            <tr style="margin:5px;padding:5px;">
                <td style=" text-align: center; "  colspan="3" >Cancel Reason :&nbsp;
                </td>
                <td style=" text-align: left" colspan="3">
                    <asp:TextBox ID="txtCancelReason" ToolTip="Enter Cancel Reason" runat="server" TextMode="MultiLine" Width="280px"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>


                </td>
            </tr>

        </table>

        <div class="filterOpDiv">
            <asp:Button ID="btnCancel" runat="server" Text="Save" CssClass="ItDoseButton"
                ToolTip="Click to Cancel" OnClick="btnCancel_Click" OnClientClick="return validate();" />
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnClose" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" ToolTip="Click to Cancel" />&nbsp;
        </div>
    </asp:Panel>
</asp:Content>

<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
	CodeFile="InternalStockTransferPatient.aspx.cs" Inherits="Design_Store_InternalStockTransferPatient"
	 %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel"
	TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script type="text/javascript" >

		$(function () {
			$('#DateFrom').change(function () {
				ChkDate();

			});

			$('#DateTo').change(function () {
				ChkDate();
			});

		});
		function ChkDate() {

			$.ajax({

				url: "../Common/CommonService.asmx/CompareDate",
				data: '{DateFrom:"' + $('#DateFrom').val() + '",DateTo:"' + $('#DateTo').val() + '"}',
				type: "POST",
				async: true,
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success: function (mydata) {
					var data = mydata.d;
					if (data == false) {
						$('#lblMsg').text('To date can not be less than from date!');
						$('#<%=btnSave.ClientID %>,#<%=btnA.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnSN.ClientID %>,#<%=btnRN.ClientID %>,#btnSearchIndent').attr('disabled', 'disabled');
						$('#<%=pnlSave.ClientID %>,#<%=pnlSearch.ClientID %>').hide();                       
					}
					else {
						$('#lblMsg').text('');
						$('#<%=btnSave.ClientID %>,#<%=btnA.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnRN.ClientID %>,#<%=btnSN.ClientID %>,#btnSearchIndent').removeAttr('disabled');
					}
				}
			});

		}

		function checkForSecondDecimal(sender, e) {
			formatBox = document.getElementById(sender.id);
			strLen = sender.value.length;
			strVal = sender.value;
			hasDec = false;
			e = (e) ? e : (window.event) ? event : null;


			if (e) {
				var charCode = (e.charCode) ? e.charCode :
							((e.keyCode) ? e.keyCode :
							((e.which) ? e.which : 0));


				if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
					for (var i = 0; i < strLen; i++) {
						hasDec = (strVal.charAt(i) == '.');
						if (hasDec)
							return false;
					}
				}
			}
			return true;
		}

		function validatedot() {
			if (($(".GridViewItemStyle").find("[id$=txtReject]").val().charAt(0) == ".")) {
				$(".GridViewItemStyle").find("[id$=txtReject]").val('');
				return false;
			}
			if (($(".GridViewStyle").find('tr').find('td').find(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val() != null)) {
				if (($(".GridViewStyle").find('tr').find('td').find(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
					$(".GridViewStyle").find('tr').find('td').find(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val('');
					return false;
				}
			}
			return true;
		}

		function RestrictDoubleEntry(btn) {
			btn.disabled = true;
			btn.value = 'Submitting...';
			__doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
		}
	</script>
	

	  <cc1:ModalPopupExtender ID="meLabel" runat="server" CancelControlID="btnCancelLabel" PopupControlID="pnlLabel"
			TargetControlID="btnhide" BehaviorID="mpePrint" DropShadow="true" BackgroundCssClass="filterPupupBackground">
		</cc1:ModalPopupExtender>
	
<asp:Panel runat="server" ID="pnlLabel" Width="820px" Height="300px" Style="display:none" CssClass="pnlVendorItemsFilter" ScrollBars="Auto">
			  <uc2:wuc_PrintPharmacyLabel ID="PrintLabel" runat="server" />
				<asp:Button ID="btnhide" runat="server" style="display:none" />
	</asp:Panel>
	<script type="text/javascript">
		function BindPopUp(IndentNo) {
			var IndentNo = $(IndentNo).closest('tr').find("span[id*=lblLedgerTransactionNo]").text();
			$find("mpePrint").show();
			BindIPDPopUp(IndentNo);
		}

	</script>
	<Ajax:ScriptManager ID="ScriptManager1" runat="server">
	</Ajax:ScriptManager>
	<div id="Pbody_box_inventory">
		<div class="POuter_Box_Inventory" style="text-align: center;">
			
				<b>IPD Patient Issue - Medical Items</b>
				<br />
				<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
			
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
				Search Requisition Criteria
			</div>
			<div style="text-align: center; margin-left: 90px;">
				<div style="visibility: hidden">
					<asp:RadioButton ID="rbtStorToDept" Text="To Department" AutoPostBack="True" Checked="true"
						runat="server" CssClass="ItDoseRadiobutton" Width="150px" GroupName="a" />
					<asp:RadioButton ID="rbtStorToPat" Text="To Patient" runat="server" 
						Width="150px" GroupName="a" AutoPostBack="true" />
				</div>
				<table style="width: 720px;border-collapse:collapse">
					<tr>
						<td style="text-align:right" >Date From :&nbsp;
						</td>
						<td  style="text-align:left">
							<asp:TextBox ID="DateFrom" runat="server" ClientIDMode="Static" 
								Width="149px">
							</asp:TextBox>
							<cc1:CalendarExtender ID="todalcal" TargetControlID="DateFrom" Format="dd-MMM-yyyy"
								runat="server">
							</cc1:CalendarExtender>
						</td>
						<td style="text-align:right">Date To :&nbsp;
						</td>
						<td style="text-align:left">
							<asp:TextBox ID="DateTo" runat="server" ClientIDMode="Static" 
								Width="149px">
							</asp:TextBox>
							<cc1:CalendarExtender ID="todate" TargetControlID="DateTo" Format="dd-MMM-yyyy" runat="server">
							</cc1:CalendarExtender>
						</td>
					</tr>
					<tr>
						<td style="text-align:right">From Department :&nbsp;
						</td>
						<td style="text-align:left">
							<asp:DropDownList ID="ddlDepartment" runat="server" 
								Width="153px">
							</asp:DropDownList>
						</td>
						<td style="text-align:right">Requisition Number :&nbsp;
						</td>
						<td style="text-align:left;" >
							<asp:TextBox ID="txtIndentNoToSearch" runat="server" Width="149px" >
							</asp:TextBox>
						</td>
					</tr>
					<tr>
						<td style="text-align:right">
                           
                           IPD No. :&nbsp;
						</td>
						<td style="text-align:left">
							<asp:TextBox ID="txtTransactionID" runat="server" 
								Width="149px" MaxLength="10">
							</asp:TextBox>
							
						</td>
						<td style="text-align:right"></td>
						<td style="text-align:left">
						   
							<asp:TextBox ID="txtIndentNo" runat="server"  ReadOnly="true"
								Visible="false">
							</asp:TextBox>
						</td>
					</tr>
					
					<tr>
						<td style="text-align:right">Patient Name :&nbsp;</td>
						<td style="text-align:left">
						   <asp:TextBox ID="txtPName" runat="server" Width="149px"></asp:TextBox> &nbsp;</td>
						<td style="text-align:right">UHID :&nbsp;</td>
						<td style="text-align:left">
						   <asp:TextBox ID="txtMrNo" runat="server"  Width="149px"></asp:TextBox>
							&nbsp;</td>
					</tr>
					
				</table>
				</div>
			 </div>
				 <div class="POuter_Box_Inventory">
					  <table style=" width:100%">
					 <tr>
						<td style="text-align:center" colspan="4" >
							<asp:Button ID="btnSearchIndent" runat="server" Text="Search"
								ClientIDMode="Static" OnClick="btnSearchIndent_Click1"  CssClass="ItDoseButton"/>
						</td>
					</tr>
						  </table>
				<div  style="text-align: center;">
					<div id="colorindication" runat="server">
						<table style=" width:75%">
							<tr>
								<td style="height: 22px">&nbsp;<asp:Button ID="btnSN" runat="server" Width="20px" Height="20px" BackColor="LightBlue"
									BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnSN_Click"
									ToolTip="Click for Open Requisition" Style="cursor: pointer;" />
								</td>
								<td style="text-align: left; height: 22px;">Pending
								</td>
								<td style="height: 22px">
									<asp:Button ID="btnRN" runat="server" Width="20px" Height="20px" BackColor="green"
										BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnRN_Click"
										ToolTip="Click for Close Requisition" Style="cursor: pointer;" />
								</td>
								<td style="text-align: left; height: 22px;">Issued
								</td>
								<td style="height: 22px">&nbsp;<asp:Button ID="btnNA" runat="server" Width="20px" Height="20px" BackColor="LightPink"
									BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnNA_Click"
									ToolTip="Click for Reject Requisition" Style="cursor: pointer;" />
								</td>
								<td style="text-align: left; height: 22px;">Reject
								</td>
								<td style="height: 22px">&nbsp;<asp:Button ID="btnA" runat="server" Width="20px" Height="20px" BackColor="Yellow"
									BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnA_Click"
									ToolTip="Click for Partial Requisition" Style="cursor: pointer;" />
								</td>
								<td style="text-align: left; height: 22px; width: 145px;">&nbsp;Partial
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
	   
		<div class="POuter_Box_Inventory">
			<asp:Panel ID="pnlSearch" runat="server">
				<div class="Purchaseheader">
					Search Results
				</div>
				<div style="text-align: center">
					<asp:GridView ID="grdIndentSearch" runat="server" CssClass="GridViewStyle" OnRowDataBound="gvGRN_RowDataBound" OnRowCommand="gvGRN_RowCommand" PageSize="8" AutoGenerateColumns="False" Width="100%">
						<AlternatingRowStyle CssClass="GridViewAltItemStyle" />
						<Columns>
							<asp:TemplateField HeaderText="S.No." HeaderStyle-Width="20px">
								<ItemTemplate>
									<%#Container.DataItemIndex+1 %>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="IPD No.">
								<ItemTemplate>
									<%# Eval("IPDNo") %>
									<asp:Label ID="lblTransactionID" runat="server" Visible="false" Text='<%# Eval("TransactionID")%>'></asp:Label>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="UHID">
								<ItemTemplate>
									<asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID")%>'></asp:Label>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="Patient Name">
								<ItemTemplate>
									<asp:Label ID="lblPName" runat="server" Text='<%# Eval("PName")%>'></asp:Label>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
							</asp:TemplateField>

							<asp:TemplateField HeaderText="Requisition Date">
								<ItemTemplate>
									<asp:Label ID="lblIndentDate" runat="server" Text='<%# Eval("dtEntry")%>'></asp:Label>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="Requisition No.">
								<ItemTemplate>
									<asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="135px" />
							</asp:TemplateField>

							<asp:TemplateField HeaderText="From Department">
								<ItemTemplate>
									<asp:Label ID="lblFromDepartment" runat="server" Text='<%# Eval("DeptFrom")%>'></asp:Label>
									<%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="User">
								<ItemTemplate>
									<asp:Label ID="lblFromUser" runat="server" Text='<%# Eval("UserName")%>'></asp:Label>
									<%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
							</asp:TemplateField>

							<asp:TemplateField HeaderText="Requisition Type">
								<ItemTemplate>
									<asp:Label ID="lblIndentType" runat="server" Text='<%# Eval("IndentType")%>'></asp:Label>
									
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="View" HeaderStyle-Width="20px">
								<ItemTemplate>
									<asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
										ImageUrl="~/Images/view.gif"
										CommandArgument='<%# Eval("IndentNo")+"#"+Eval("DeptFrom")+"#"+Eval("TransactionID")+"#"+Eval("DeptFrom")+"#"+Eval("UserName")+"#"+Eval("StatusNew")+"#"+Eval("IPDCaseType_ID")+"#"+Eval("room_ID")  %>'
										Visible='<%#Util.GetBoolean(Eval("VIEW")) %>' />
									<asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status")%>' Visible="false"></asp:Label>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="View Details">
								<ItemTemplate>
									<asp:ImageButton ID="imbViews" runat="server" CausesValidation="false" CommandName="AViewDetail"
										ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
									<asp:Label ID="lblStat" runat="server" Visible="false"></asp:Label>
								</ItemTemplate>
								<ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
							</asp:TemplateField>
							 <asp:TemplateField HeaderText="Print Label">
								<ItemTemplate>
									<img src="../../Images/print.gif" style="cursor:pointer" title="Click To Print Label"  ID="btnimgPrint" onclick="BindPopUp(this);" />
									 <asp:Label ID="lblLedgerTransactionNo" Style=" display:none" runat="server" Text='<%# Eval("indentno") %>'></asp:Label>
								</ItemTemplate>
								<ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
							</asp:TemplateField>
							<asp:TemplateField HeaderText="Reject Reason" Visible="false">
								<ItemTemplate>
									<asp:TextBox ID="txtReason" runat="server" CssClass="ItDoseTextinputNum" Width="150px"></asp:TextBox>
								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
							</asp:TemplateField>

							<asp:TemplateField HeaderText="Reject" HeaderStyle-Width="20px" Visible="false">
								<ItemTemplate>
									<asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="AReject" ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("IndentNo")+"#"+ Container.DataItemIndex %>' />

								</ItemTemplate>
								<ItemStyle CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" />
							</asp:TemplateField>


							<asp:TemplateField HeaderText="StatusNew" Visible="false">
								<ItemTemplate>
									<asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
									<asp:Label ID="Label2" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
								</ItemTemplate>
								<ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
								<HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
							</asp:TemplateField>


						</Columns>
					</asp:GridView>
					&nbsp;&nbsp;<br />
				</div>
			</asp:Panel>
			<asp:Panel ID="pnlSave" runat="server">
				<div class="Purchaseheader">
					Search Results
				</div>
				<table style="width: 100%">
					<tr>
						<td style="width: 15%; text-align: right;">Patient Name :
						</td>
						<td style="width: 20%; text-align: left">
							<asp:Label ID="lblPatientName" runat="server"   CssClass="ItDoseLabelSp"></asp:Label>
						</td>
						<td style="width: 10%; text-align: right;">
                             
                            <asp:Label ID="lblPatientTypeID" runat="server" Text="IPD No."> </asp:Label>
                            :

						</td>
						<td style="width: 20%; text-align: left">
                            <asp:Label ID="lbllblTransactionIDDisplay" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
							<asp:Label ID="lblTransactionID" runat="server" CssClass="ItDoseLabelSp" style="display:none" ></asp:Label>
                            <asp:Label ID="lblLedgerTransactionNo" runat="server" CssClass="ItDoseLabelSp" style="display:none" ></asp:Label>
						</td>
						<td style="width: 10%; text-align: right">Panel :
						</td>
						<td style="width: 25%; text-align: left">
							<asp:Label ID="lblPanelName" runat="server" Width="166px" CssClass="ItDoseLabelSp"></asp:Label>
						</td>
					</tr>
					<tr>
						<td style="width: 15%; text-align: right;">Age/Sex :
						</td>
						<td style="width: 20%; text-align: left">
							<asp:Label ID="lblAge" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
						</td>
						<td style="width: 10%; text-align: right">UHID :
						</td>
						<td style="width: 20%; text-align: left">
							<asp:Label ID="lblRegistrationNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
						</td>
						<td style="width: 10%; text-align: right;">Doctor :
						</td>
						<td style="width: 25%; text-align: left;">
							<asp:Label ID="lblDocName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
						</td>
					</tr>
					<tr>
						<td style="width: 15%; text-align: right">Room Name :
						</td>
						<td style="width: 20%; text-align: left;">
							<asp:Label ID="lblRoomName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
						</td>
						<td style="width: 10%; text-align: right">From Dept. :
						</td>
						<td style="width: 20%">
							<asp:Label ID="lblDepartment" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
						</td>
						<td style="width: 10%; text-align: right;">User :
						</td>
						<td style="width: 25%; text-align: left;">
							<asp:Label ID="lblUserName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
							<asp:Label ID="lblIPDCaseType_ID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
							<asp:Label ID="lblRoom_ID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
						</td>
					</tr>
					<tr>
						<td style="width: 15%; text-align: right"></td>
						<td style="width: 20%">
							<asp:Label ID="lblPanelId" runat="server" Visible="false"></asp:Label>
						</td>
						<td style="width: 10%; text-align: right"></td>
						<td style="width: 20%">
							<asp:Label ID="lblPatientStatus" runat="server" Visible="False"></asp:Label>
							<asp:Label ID="lblPatientType" runat="server" Visible="False"></asp:Label>
							<asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label>
						</td>
						<td style="width: 10%"></td>
						<td style="width: 25%"></td>
					</tr>
				</table>
				<asp:Repeater ID="grdIndentDetails" OnItemCommand="grdIndentDetails_ItemCommand"
					runat="server">
					<HeaderTemplate>

						<table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;">
							<tr style="text-align: center; background-color: #afeeee;">
								<th class="GridViewHeaderStyle" scope="col">&nbsp;</th>
								<th class="GridViewHeaderStyle" scope="col">Item Name</th>
								<th class="GridViewHeaderStyle" scope="col">Requested Qty.</th>
								<th class="GridViewHeaderStyle" scope="col">Issued Qty.</th>
								<th class="GridViewHeaderStyle" scope="col">Rejected Qty.</th>
								<th class="GridViewHeaderStyle" scope="col">Dept. Available Qty.</th>
								<th class="GridViewHeaderStyle" scope="col">Store Available Qty.</th>
								<th class="GridViewHeaderStyle" scope="col">Pending Qty.</th>
								<th class="GridViewHeaderStyle" scope="col">Narration</th>
								<th class="GridViewHeaderStyle" scope="col">Reject</th>
								<th class="GridViewHeaderStyle" scope="col">Reason</th>
								<th class="GridViewHeaderStyle" scope="col" style="display: none"></th>


							</tr>
					</HeaderTemplate>
					<ItemTemplate>
						<tr>
							<td class="GridViewItemStyle">
								<asp:CheckBox ID="chkSelect" runat="server" />
								<asp:Label ID="lblIndentID" runat="server" Text='<%# Eval("id") %>' Visible="false"></asp:Label>
								<asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo") %>' Visible="false"></asp:Label></td>
							<td class="GridViewItemStyle" style="text-align: left;">
								<asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
								<asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
							</td>
							<td class="GridViewItemStyle" style="text-align:center">
								<asp:Label ID="lblRequestedQty" runat="server" Text='<%# Eval("ReqQty") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle" style="text-align:center">
								<asp:Label ID="lblIssuedQty" runat="server" Text='<%# Eval("ReceiveQty") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle" style="text-align:center">
								<asp:Label ID="lblRejectedQty" runat="server" Text='<%# Eval("RejectQty") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle" style="text-align:center">
								<asp:Label ID="lblDeptAvailQty" runat="server" Text='<%# Eval("DeptAvailQty") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle" style="text-align:center">
								<asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle" style="text-align:center">
								<asp:Label ID="lblPendingQty" runat="server" Text='<%# Eval("PendingQty") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle">
								<asp:Label ID="Label1" runat="server" ForeColor="Brown" Text='<%# Eval("Narration") %>'></asp:Label>
							</td>
							<td class="GridViewItemStyle">
								<asp:TextBox ID="txtReject" runat="server" CssClass="ItDoseTextinputNum"  Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
								<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
									ValidChars="." TargetControlID="txtReject">
								</cc1:FilteredTextBoxExtender>
								<asp:TextBox ID="txtIssueingQty" runat="server" CssClass="ItDoseTextinputNum" Width="50px"
									Style="display: none;"></asp:TextBox>
							</td>
							<td class="GridViewItemStyle">
								<asp:TextBox ID="txtReason" runat="server" CssClass="ItDoseTextinputNum" Width="100px"></asp:TextBox></td>



							<td id="IssueBtn" class="GridViewItemStyle">
								<asp:ImageButton ID="imgMore" ImageUrl="~/Images/plus_in.gif" CommandArgument='<%# Eval("ItemID") %>'
									CommandName="showMore" runat="server" AlternateText="Show" />
							</td>


							<td class="GridViewItemStyle" style="display: none;">
								<asp:Label ID="lblType_ID" runat="server" Text='<%# Eval("Type_ID") %>'></asp:Label></td>

							<td class="GridViewItemStyle" style="display: none;">
								<asp:Label ID="lblServiceItemId" runat="server" Text='<%# Eval("ServiceItemId") %>'></asp:Label></td>

							<td class="GridViewItemStyle" style="display: none;">
								<asp:Label ID="lblToBeBilled" runat="server" Text='<%# Eval("ToBeBilled") %>'></asp:Label></td>

						</tr>
						<tr>
							<td colspan="9">


								<asp:Repeater ID="grdItem" OnItemCommand="grdItem_ItemCommand" runat="server">
									<HeaderTemplate>
										<table class="GridViewStyle" style="border-collapse: collapse;">
											<tr style="text-align: center; background-color: #afeeee;">

												<th class="GridViewHeaderStyle" scope="col">Batch</th>
												<th class="GridViewHeaderStyle" scope="col">Expiry</th>
												<th class="GridViewHeaderStyle" scope="col">Buy Price</th>
												<th class="GridViewHeaderStyle" scope="col">Selling Price</th>
												<th class="GridViewHeaderStyle" scope="col">Avail Qty.</th>
												<th class="GridViewHeaderStyle" scope="col">Unit</th>
												<th class="GridViewHeaderStyle" scope="col">Issue Qty.</th>
												<th class="GridViewHeaderStyle" scope="col" style="display: none">Search Genric</th>


											</tr>
									</HeaderTemplate>
									<ItemTemplate>
										<tr>

											<td class="GridViewItemStyle">
												<asp:Label ID="lblBatchNumber1" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
											</td>
											<td class="GridViewItemStyle">
												<asp:Label ID="lblMedExpiryDate1" runat="server" Text='<%# Eval("MedExpiryDate") %>'></asp:Label>                                                 
											</td>
											<td style="text-align:center">
												<asp:Label ID="lblUnitPrice1" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
											</td>
											<td style="text-align:center">
												<asp:Label ID="lblMRP1" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
											</td>
											<td style="text-align:center">

												<asp:Label ID="lblAvailQty1" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
											</td>
											<td>
												<asp:Label ID="lblUnitType1" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
											</td>
											<td>
												<asp:TextBox ID="txtIssueQty1" runat="server" CssClass="ItDoseTextinputNum" Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
												<asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtIssueQty1" Type="Double" MinimumValue="0.001" MaximumValue='<%# Eval("AvailQty") %>'
													runat="server" ErrorMessage="*"></asp:RangeValidator>
												<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers" ValidChars="." TargetControlID="txtIssueQty1">
												</cc1:FilteredTextBoxExtender>
												<asp:Label ID="lblItemIDnew1" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
												<asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
												<asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="False"></asp:Label>
												<asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>' Visible="False"></asp:Label>
											</td>
											<td>
												<asp:ImageButton ID="imgMore1" ImageUrl="~/Images/plus_in.gif" Visible="false" CommandArgument='<%# Eval("ItemID") %>'
													CommandName="showMore" runat="server" AlternateText="Show" />
											</td>
										</tr>




										<tr>
											<td colspan="9">
												<asp:GridView ID="grdItemNew" runat="server" Visible="false" AutoGenerateColumns="False"
													CssClass="GridViewStyle">
													<AlternatingRowStyle CssClass="GridViewAltItemStyle" />
													<Columns>

														<asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblItemNamenew" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
															</ItemTemplate>

														</asp:TemplateField>
														<asp:TemplateField HeaderText="Batch No." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblBatchNumbernew" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
															</ItemTemplate>

														</asp:TemplateField>
														<asp:TemplateField HeaderText="Expiry" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
															 <asp:Label ID="lblMedExpiryDatenew" runat="server" Text='<%# Eval("MedExpiryDate") %>'></asp:Label>

															  
															</ItemTemplate>
														</asp:TemplateField>
														<asp:TemplateField HeaderText="Buy Price" Visible="false" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblUnitPricenew" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>
														<asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblMRPnew" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>
														<asp:TemplateField HeaderText="Avail. Qty." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblAvailQtynew" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>




														<asp:TemplateField HeaderText="Unit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblUnitTypenew" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>

														<asp:TemplateField HeaderText="Issue Qty." HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:TextBox ID="txtIssueQtynew" runat="server" CssClass="ItDoseTextinputNum" Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
																<asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtIssueQtynew" Type="Double" MinimumValue="0.001" MaximumValue='<%# Eval("AvailQty") %>'
																	runat="server" ErrorMessage="*"></asp:RangeValidator>
																<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers" ValidChars="." TargetControlID="txtIssueQtynew">
																</cc1:FilteredTextBoxExtender>

															</ItemTemplate>
														</asp:TemplateField>

														<asp:TemplateField Visible="false">
															<ItemTemplate>
																<asp:Label ID="lblItemIDnew" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblStockIDnew" runat="server" Text='<%# Eval("StockID") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblSubCategorynew" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblType_IDnew" runat="server" Text='<%# Eval("Type_ID") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblServiceItemIdnew" runat="server" Text='<%# Eval("ServiceItemId") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblToBeBillednew" runat="server" Text='<%# Eval("ToBeBilled") %>' Visible="false"></asp:Label>
																 <asp:Label ID="lblIsExpirablenew" runat="server" Text='<%# Eval("IsExpirable") %>' Visible="false"></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>

													</Columns>
													<EmptyDataTemplate>
														<tr>
															<td>
																<label style="background-color: Red; color: #FFFFFF;">
																	No Stock Available of Generic
																</label>
															</td>
														</tr>
													</EmptyDataTemplate>
												</asp:GridView>
											</td>
										</tr>

									</ItemTemplate>
									<FooterTemplate>
										</table>
			
									</FooterTemplate>
								</asp:Repeater>

								<asp:Repeater ID="grdItemGenric" OnItemCommand="grdItemGenric_ItemCommand" Visible="false" runat="server">
									<HeaderTemplate>
										<table class="GridViewStyle"  style="border-collapse: collapse;">
											<tr style="text-align: center; background-color: #afeeee;">
												<th class="GridViewHeaderStyle" scope="col">Stock</th>
												<th class="GridViewHeaderStyle" scope="col" style="display: none">SearchGenric</th>



											</tr>
									</HeaderTemplate>
									<ItemTemplate>
										<tr>

											<td>
												<label style="background-color: Red; color: #FFFFFF;">
													No Stock Available
												</label>
											</td>
											<td>
												<asp:Label ID="lblItemIDGenric" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
											</td>
											<td>

												<asp:ImageButton ID="imgMoregenric" Visible="false" ImageUrl="~/Images/plus_in.gif" CommandArgument='<%# Eval("ItemID") %>'
													CommandName="showMore" runat="server" AlternateText="Show" />

											</td>


										</tr>




										<tr>
											<td colspan="9" style="text-align: center;">
												<asp:GridView ID="grdItemNewgenric" runat="server" Visible="false" AutoGenerateColumns="False"
													CssClass="GridViewStyle">
													<AlternatingRowStyle CssClass="GridViewAltItemStyle" />
													<Columns>


														<asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblItemNamenewgenric" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
															</ItemTemplate>

														</asp:TemplateField>


														<asp:TemplateField HeaderText="Batch No." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblBatchNumbernewgenric" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
															</ItemTemplate>

														</asp:TemplateField>
														<asp:TemplateField HeaderText="Expiry" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblMedExpiryDateGenric" runat="server" Text='<%# Eval("MedExpiryDate") %>'></asp:Label>
															  
															</ItemTemplate>
														</asp:TemplateField>
														<asp:TemplateField HeaderText="Buy Price" Visible="false" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblUnitPricenewgenric" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>
														<asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblMRPnewgenric" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>
														<asp:TemplateField HeaderText="Avail. Qty." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblAvailQtynewgenric" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>




														<asp:TemplateField HeaderText="Unit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:Label ID="lblUnitTypenewgenric" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
															</ItemTemplate>
														</asp:TemplateField>

														<asp:TemplateField HeaderText="Issue Qty." HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
															<ItemTemplate>
																<asp:TextBox ID="txtIssueQtynewgenric" runat="server" CssClass="ItDoseTextinputNum" Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
																<asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtIssueQtynewgenric" Type="Double" MinimumValue="0.001" MaximumValue='<%# Eval("AvailQty") %>'
																	runat="server" ErrorMessage="*"></asp:RangeValidator>
																<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers" ValidChars="." TargetControlID="txtIssueQtynewgenric">
																</cc1:FilteredTextBoxExtender>
																<asp:Label ID="lblItemIDnewgenric" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
																<asp:Label ID="lblStockIDnewgenric" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
																<asp:Label ID="lblSubCategorynewgenric" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="False"></asp:Label>

																<asp:Label ID="lblType_IDnewgenric" runat="server" Text='<%# Eval("Type_ID") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblServiceItemIdnewgenric" runat="server" Text='<%# Eval("ServiceItemId") %>' Visible="false"></asp:Label>
																<asp:Label ID="lblToBeBillednewgenric" runat="server" Text='<%# Eval("ToBeBilled") %>' Visible="false"></asp:Label>
															   <asp:Label ID="lblIsExpirableGenric" runat="server" Text='<%# Eval("IsExpirable") %>' Visible="false"></asp:Label>


															</ItemTemplate>
														</asp:TemplateField>



													</Columns>
													<EmptyDataTemplate>
														<tr>
															<td>
																<label style="background-color: Red; color: #FFFFFF;">
																	No Stock Available of Generic
																</label>
															</td>
														</tr>
													</EmptyDataTemplate>
												</asp:GridView>
											</td>
										</tr>
									</ItemTemplate>
									<FooterTemplate>
										</table>
			
									</FooterTemplate>
								</asp:Repeater>

							</td>
						</tr>
					</ItemTemplate>
					<FooterTemplate>
						</table>
					</FooterTemplate>
				</asp:Repeater>
				<div style="text-align: center;">
					<asp:CheckBox ID="chkPrint" runat="server" Text="Print " Checked="true" />
                    <asp:CheckBox ID="chkDischargeMedicine" runat="server" Text="Discharge Medicine " Checked="true" />
					<asp:Button ID="btnSave" runat="server" Text="Save"  OnClick="btnSave_Click"
						OnClientClick="RestrictDoubleEntry(this);" CssClass="ItDoseButton"/>
				</div>
			</asp:Panel>
		</div>
	</div>
	<asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 850px; height: 350px;" ScrollBars="Auto">
		<div>
			<table>
				<tr>
					<td style="text-align: center;">
						<label>
							<strong>Requisition Detail:</strong></label>
					</td>
				</tr>
				<tr>
					<td valign="top" style="text-align: center;">
						<asp:GridView ID="grdIndentdtl" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
							Width="850px" OnRowDataBound="grdIndentdtl_RowDataBound">
							<AlternatingRowStyle CssClass="GridViewAltItemStyle" />
							<Columns>
								<asp:TemplateField HeaderText="S.No.">
									<ItemTemplate>
										<%#Container.DataItemIndex+1 %>
									</ItemTemplate>
									<ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Requisition No.">
									<ItemStyle CssClass="GridViewLabItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
									<ItemTemplate>
										<asp:Label ID="lblitemIndentNo" runat="server" Text='<%#Util.GetString(Eval("IndentNo")) %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>

								<asp:TemplateField HeaderText="Item Name">
									<ItemStyle CssClass="GridViewLabItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
									<ItemTemplate>
										<asp:Label ID="lblItemname" runat="server" Text='<%#Util.GetString(Eval("ItemName")) %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>

								<asp:TemplateField HeaderText="Unit Type">
									<ItemStyle CssClass="GridViewLabItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
									<ItemTemplate>
										<asp:Label ID="lblItemUnitType" runat="server" Text='<%#Util.GetString(Eval("UnitType")) %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>

								<asp:TemplateField HeaderText="Requested Qty.">
									<ItemStyle CssClass="GridViewLabItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
									<ItemTemplate>
										<asp:Label ID="lblItemQty" runat="server" Text='<%#Util.GetString(Eval("ReqQty")) %>'></asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:BoundField HeaderText="Issue Qty." DataField="SoldUnits" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" />
								<asp:BoundField HeaderText="Received Qty." DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
								<asp:BoundField HeaderText="Pending Qty." DataField="PendingQty" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
								<asp:BoundField HeaderText="Rejected Qty." DataField="RejectQty" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
								<asp:BoundField HeaderText="Date" DataField="DATE" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" />
								<asp:BoundField HeaderText="Dose" DataField="Dose" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" />
								<asp:BoundField HeaderText="Times" DataField="Timing" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" />
								<asp:BoundField HeaderText="Duration" DataField="Duration" ItemStyle-CssClass="GridViewItemStyle"
									HeaderStyle-CssClass="GridViewHeaderStyle" />
								<asp:TemplateField Visible="false">
									<ItemStyle CssClass="GridViewLabItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
									<ItemTemplate>

										<asp:Label ID="lblname" runat="server" Text=' <%#Eval("Itemname") %>'
											Visible="false"></asp:Label>
										<asp:Label ID="lblReqqty" runat="server" Text=' <%#Eval("Reqqty") %>'
											Visible="false"></asp:Label>
										<asp:Label ID="lblUnittype" runat="server" Text=' <%#Eval("Unittype") %>'
											Visible="false"></asp:Label>
										<asp:Label ID="lblIndentno" runat="server" Text=' <%#Eval("IndentNo") %>'
											Visible="false"></asp:Label>


									</ItemTemplate>
								</asp:TemplateField>

								<asp:TemplateField HeaderText="StatusNew" Visible="false">
									<ItemTemplate>
										<asp:Label ID="lblStatusNew1" runat="server"></asp:Label>
									</ItemTemplate>
									<ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
									<HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
								</asp:TemplateField>
							</Columns>
						</asp:GridView>
					</td>
				</tr>
				<tr>
					<td style="text-align: center;">
						<asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="ItDoseButton" />
					</td>
				</tr>
			</table>
		</div>
	</asp:Panel>
	<cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
		PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="Panel2"
		TargetControlID="btn1" X="80" Y="100">
	</cc1:ModalPopupExtender>
	<div style="display: none;">
		<asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/>
	</div>
</asp:Content>

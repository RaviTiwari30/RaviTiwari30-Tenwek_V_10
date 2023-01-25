<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
	CodeFile="EditSetItemDetail.aspx.cs" Inherits="Design_CSSD_EditSetItemDetail"
	EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral,
 PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script type="text/javascript" >
		function MoveUpAndDownText(textbox2, listbox2) {
			var f = document.theSource;
			var listbox = listbox2;
			var textbox = textbox2;
			if (event.keyCode == 13) {
				///__doPostBack('ListBox1','')
				textbox.value = "";
			}
			if (event.keyCode == '38' || event.keyCode == '40') {
				if (event.keyCode == '40') {
					for (var m = 0; m < listbox.length; m++) {
						if (listbox.options[m].selected == true) {
							if (m + 1 == listbox.length) {
								return;
							}
							listbox.options[m + 1].selected = true;
							textbox.value = listbox.options[m + 1].text;
							return;
						}
					}
					listbox.options[0].selected = true;
				}
				if (event.keyCode == '38') {
					for (var m = 0; m < listbox.length; m++) {
						if (listbox.options[m].selected == true) {
							if (m == 0) {
								return;
							}
							listbox.options[m - 1].selected = true;
							textbox.value = listbox.options[m - 1].text;
							return;
						}
					}
				}
			}
		}
	</script>
	<script type="text/javascript">
		var PatientData = "";
		$(document).ready(
					  function () {

						  $("#btnEdit").click(EditItem);
						  $("#btnSave").click(SaveData);
						  $("#btnAdd").click(AddItem);
						  $("#<%=ddlSetItem.ClientID %>").change(EditItem);
						  $("#p1").hide();
						  $("#p2").hide();
						  $("#p3").hide();
					  });
					  var RowCount;
					  var setId;
					  function AddItem() {
						  $("#<%=lblmsg.ClientID %>").text('');
			$("#btnSave").attr('style', 'display:""');
			var ItemName = $("#<%=lstitems.ClientID %> option:selected").text();
			var ItemID = $("#<%=lstitems.ClientID %> option:selected").val();
			var Qty = $("#<%=txtQty.ClientID %>").val();
			var text = $("#<%=txtQty.ClientID %>").val().charAt(0);
			if ($("#<%=lstitems.ClientID %> option:selected").length == "0") {
				DisplayMsg('MM018', 'ctl00_ContentPlaceHolder1_lblmsg');
				//$("#<%=lblmsg.ClientID %>").text('Please Select Item');
				$("#<%=lstitems.ClientID %>").focus();
				return;
			}
			if ($("#tb_grdLabSearch tr").length == "1") {
				$("#btnSave").hide();
			}
			else {
				$("#btnSave").show();
			}
			if (text == "0") {
				DisplayMsg('MM246', 'ctl00_ContentPlaceHolder1_lblmsg');
				//$("#<%=lblmsg.ClientID %>").text('Please Enter Quantity');
				$("#<%=txtQty.ClientID %>").focus();
				return false;
			}
			if (Qty == "" || Qty == "0") {
				DisplayMsg('MM246', 'ctl00_ContentPlaceHolder1_lblmsg');
				//$("#<%=lblmsg.ClientID %>").text('Please Enter Quantity');
				$("#<%=txtQty.ClientID %>").focus();
				return;
			}
			RowCount = $("#tb_grdLabSearch tr").length;
			RowCount = RowCount + 1;
			$("#btnSave").show();
			var AlreadySelect = 0;

			if (RowCount > 2) {

				$("#tb_grdLabSearch tr").find("#ItemID").each(function () {
					$row = $(this).closest('tr');
					if ($row.find('#ItemID').text() == ItemID) {
						AlreadySelect = 1;
						return;
					}
				});

				if (AlreadySelect == "1") {
					DisplayMsg('MM035', 'ctl00_ContentPlaceHolder1_lblmsg');
					return;
				}
				if ($("#<%=ddlSetItem.ClientID %>  option:selected").val() != setId) {
					alert('SetName Cannot Change');
					$("#<%=ddlSetItem.ClientID %>").css("background-color", "red");
					$("#<%=ddlSetItem.ClientID %>").focus();
					return;
				}
				else {
					$("#<%=ddlSetItem.ClientID %>").css("background-color", "white");
				}
			}

			setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();

			var setName = $("#<%=ddlSetItem.ClientID %>  option:selected").text();

			if (setName.toUpperCase() == "SELECT") {
				DisplayMsg('MM242', 'ctl00_ContentPlaceHolder1_lblmsg');
				// $("#<%=lblmsg.ClientID %>").text('Please Select Set');
				$("#<%=ddlSetItem.ClientID %>").focus();
				return;
			}
			$("#<%=lblmsg.ClientID %>").text('');
			if (AlreadySelect == "0") {
				var newRow = $('<tr />').attr('id', 'tr_' + ItemID);

				newRow.html('<td class="GridViewLabItemStyle" >' + (RowCount - 1) +
					 '</td><td class="GridViewLabItemStyle"  >' + setId +
					 '</td><td class="GridViewLabItemStyle" >' + setName +
					 '</td><td id="ItemID" class="GridViewLabItemStyle" style="display:none">' + ItemID +
					 '</td><td  class="GridViewLabItemStyle" >' + ItemName +

					 '</td><td  class="GridViewLabItemStyle"  style="text-align:center;">' + Qty +
					 '<td  class="GridViewLabItemStyle" style="text-align:center; " ><input id="txtRecieveNew" maxlength="3" onpaste="return false" type="text" value="' + Qty + '" size="5" onkeyup=CheckQtyRecive(this)>' +

					 '</td><td class="GridViewLabItemStyle" style="text-align:center;"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove" style="text-align:center;"/></td>'
					);
				$("#tb_grdLabSearch").append(newRow);
				$("#tb_grdLabSearch").show();
				$("#<%=txtQty.ClientID %>").val('');
			}
			else {
				DisplayMsg('MM035', 'ctl00_ContentPlaceHolder1_lblmsg');
			}
			$('#<% = txtitemsearch.ClientID %>').val('');
			$('#<% = txtitemsearch.ClientID %>').focus();
		}
		function SaveData() {
			$("#btnSave").attr('disabled', true);
			var Itemdata = "";
			var IsReturn = 0;
			$("#tb_grdLabSearch").find("#txtRecieveNew").each(function () {
				$row = $(this).closest('tr');

				if ($row.find('#txtRecieveNew').val() == "0" || $row.find('#txtRecieveNew').val() == "") {
					$("#<%=lblmsg.ClientID %>").text('Please Enter Valid Quantity');
					$row.find('#txtRecieveNew').focus();
					IsReturn = 1;
					$("#btnSave").attr('disabled', false);
					return;
				}
			});
			if (IsReturn == "1") {
				DisplayMsg('MM249', 'ctl00_ContentPlaceHolder1_lblmsg');
				$("#btnSave").attr('disabled', false);
				return;
			}
			$("#tb_grdLabSearch tr").each(function () {
				var id = $(this).closest("tr").attr("id");
				var i = 1;
				if (id != "Header") {
					$(this).find("td").each(function () {
						if (i <= 6) {
							Itemdata += $(this).html() + '|';
						}
						else if (i == 7) {
							Itemdata += $(this).find('#txtRecieveNew').val() + '|';
						}
						i++;

					});
					Itemdata = Itemdata + "^"
				}
			});
			if (Itemdata == "") {
				$("#<%=lblmsg.ClientID %>").text('Please select an item');
				$("#btnSave").attr('disabled', false);
				return;
			}
			$("#<%=lblmsg.ClientID %>").text('');
			$.ajax({
				url: "Services/SetItems.asmx/EditSetItemsDetails",
				data: '{ItemData: "' + Itemdata + '"}', // parameter map
				type: "POST", // data has to be Posted    	        
				contentType: "application/json; charset=utf-8",
				timeout: 120000,
				dataType: "json",
				success: function (result) {
					if (result.d == "1") {
						//$('ddlSetItem').find('selected', 'selected')
						$("#tb_grdLabSearch tr:not(:first)").remove();
						$("#tb_grdLabSearch").hide();
						$("#<%=lblmsg.ClientID %>").text('Record Saved Successfully');
						$("#btnSave").hide();
						$("#p1").hide();
						$("#p2").hide();
						$("#p3").hide();
						$('#btnAdd').attr('style', 'display:none');
						$("#<%=ddlSetItem.ClientID%>").get(0).selectedIndex = 0;
					}
					else {
						$("#<%=lblmsg.ClientID %>").text('Record Not Saved');
					}

					$("#btnSave").attr('disabled', false);
				},
				error: function (xhr, t, status) {
					if (t === "timeout") {
						$("#<%=lblmsg.ClientID %>").text('timeout');
				}
					DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
					alert("Error has occured Record Not saved ");
					$("#btnSave").attr('disabled', false);
					window.status = status + "\r\n" + xhr.responseText;
				}
			});
	}
	var PatientData = "";
	function EditItem() {
		$("#<%=lblmsg.ClientID %>").text('');
			setId = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
			var ItemData = $("#<%=ddlSetItem.ClientID %>  option:selected").val();
			if ($("#<%=ddlSetItem.ClientID %>  option:selected").text().toUpperCase() == "SELECT") {
				$("#<%=lblmsg.ClientID %>").text('Please Select Set Name');
				$("#p1").hide();
				$("#p2").hide();
				$("#p3").hide();
				$('#btnAdd').attr('style', 'display:none');
				$('#btnSave').attr('style', 'display:none');
				$('#PatientLabSearchOutput').hide();
				return;
			}
			
			$.ajax({
				url: "Services/SetItems.asmx/LoadSetItemsWithOutStock",
				data: '{SetID:' + ItemData + '}',
				type: "POST",
				contentType: "application/json;charset=utf-8",
				timeout: 120000,
				dataType: "json",
				success: function (result) {
					PatientData = jQuery.parseJSON(result.d);
					var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
					$('#PatientLabSearchOutput').html(output);
					$('#PatientLabSearchOutput').show();
					$('#<%=lstitems.ClientID %>').show();
					$('#<%=txtitemsearch.ClientID %>').show();
					//$('#<%=txtitemsearchByCatlogID.ClientID %>').show();
					$('#<%=txtQty.ClientID %>').show();
					$('#btnAdd').attr('style', 'display:""');
					$('#btnSave').attr('style', 'display:""');
					$("#p1").show();
					$("#p2").show();
					$("#p3").show();

					$("#tb_grdLabSearch").find("#txtRecieveNew").each(function () {
						$row = $(this).closest('tr');
						var input = $row.find('#txtRecieveNew');
						var len = $row.find('#txtRecieveNew').val().length;
						input.focus();
						input.setCursorToTextEnd();
					});
				},
				error: function (xhr, status) {
					DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
					//$("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
					$("#btnSave").attr('disabled', false);
					window.status = status + "\r\n" + xhr.responseText;
				}
			});
		}

		(function ($) {
			$.fn.setCursorToTextEnd = function () {
				$initialVal = this.val();
				this.val($initialVal + ' ');
				this.val($initialVal);
			};
		})(jQuery);

		function CheckQty(RecievedQty) {

			if (eval($(RecievedQty).val()) > eval($(RecievedQty).closest('tr').find('#StockQty').text())) {
				alert('Received Qunatity cannot greater than Stock Quantity');
				$(RecievedQty).val("0");
				return;
			}

			var TotalSetQunatity = $(RecievedQty).closest('table').closest('tr').find('#tdSetQuantity').text();
			var total = 0;

			$(RecievedQty).closest('table').find("#txtRecievedQty").each(function () {
				total = eval(total + eval($(this).val()));
			});

			if (eval(total) > eval(TotalSetQunatity)) {
				alert('Received Qunatity cannot greater than Total Set Qunatity');
				$(RecievedQty).val("0");
				return;
			}
		}
		function CheckQtyRecive(RecievedQty) {
			$(RecievedQty).val(Number($(RecievedQty).val()));
			var total = 0;

			var TotalSetQunatity = $(RecievedQty).closest('tr').find('#tdSetQuantity').text();
			var TotalStockQunatity = $(RecievedQty).closest('tr').find('#tdStockQtyNew').text();
			total = eval($(RecievedQty).val());
			if (total == 0) {
				$(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
					if ($(this).attr("id") != "HeaderStock") {
						$(this).find('#txtRecievedQty').val("0");
					}
				});
				$(RecievedQty).val("0");
				alert('Please Enter Quantity');
				return;
			}
			if (eval(total) > eval(TotalSetQunatity)) {
				alert('Received Qunatity cannot  greater than Total Set Qunatity');
				$(RecievedQty).val("0");
				$(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
					if ($(this).attr("id") != "HeaderStock") {
						$(this).find('#txtRecievedQty').val("0");
					}
				});

				return;
			}
			if (eval(total) > eval(TotalStockQunatity)) {
				alert('Received Qunatity cannot greater than Total Stock Qunatity');
				$(RecievedQty).val("0");
				$(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
					if ($(this).attr("id") != "HeaderStock") {
						$(this).find('#txtRecievedQty').val("0");
					}
				});
				return;
			}
			var quantity = total;
			$(RecievedQty).closest('td').find("#tb_grdStockData tr").each(function () {
				if ($(this).attr("id") != "HeaderStock" && Number(quantity) > 0) {
					var StockQty = $(this).find('#StockQty').text();

					if (Number(quantity) > Number(StockQty)) {
						$(this).find('#txtRecievedQty').val(StockQty);
						quantity = Number(quantity) - Number(StockQty);
					}
					else {
						$(this).find('#txtRecievedQty').val(quantity);
						quantity = 0;
					}
				}
			});
		}

		function DeleteRow(rowid) {
			var row = rowid;
			$(row).closest('tr').remove();
			RowCount = RowCount - 1;
			if ($("#tb_grdLabSearch tr").length == "0") {
				$("#btnSave").hide();
				$("#tb_grdLabSearch").hide();
			}
			else {
				$("#btnSave").show();
			}
		}
		function CheckQtyRecive(RecievedQty) {
			var TDSAmt = $(RecievedQty).val();

			if (TDSAmt.match(/[^0-9]/g)) {
				TDSAmt = TDSAmt.replace(/[^0-9]/g, '');
				$(RecievedQty).val(TDSAmt)
				return;
			}
			$(RecievedQty).val(Number($(RecievedQty).val()));
		}
		function chngcur() {
			document.body.style.cursor = 'pointer';
		}
		$(document).ready(function () {
			$('#<%=txtQty.ClientID %>').keyup(function (e) {
				var val = $(this).val();
				while (val.substring(0, 1) === '0') {
					val = val.substring(1);
				}
				$(this).val(val);
			});
			$("#tb_grdLabSearch tr").each(function () {
				$row = $(this).closest('tr');
				alert('hi');
				$row.find('#txtRecieveNew').keyup(function (e) {
					var val = $(this).val();
					alert(val);
					while (val.substring(0, 1) === '0') {
						val = val.substring(1);
					}
					$(this).val(val);
				});
			});
		});

	</script>
	<script type="text/javascript" >
		function splcharval(id) {
			id.value = id.value.replace(/[#|\']/g, '');
		}
		//For Search By Word
		function MoveUpAndDownText(textbox2, listbox2) {

			var f = document.theSource;
			var listbox = listbox2;
			var textbox = textbox2;

			if (event.keyCode == 13) {
				///__doPostBack('ListBox1','')
				textbox.value = "";
			}

			if (event.keyCode == '38' || event.keyCode == '40') {
				if (event.keyCode == '40') {
					for (var m = 0; m < listbox.length; m++) {
						if (listbox.options[m].selected == true) {
							if (m + 1 == listbox.length) {
								return;
							}
							listbox.options[m + 1].selected = true;
							textbox.value = listbox.options[m + 1].text;
							return;
						}
					}

					listbox.options[0].selected = true;
				}
				if (event.keyCode == '38') {
					for (var m = 0; m < listbox.length; m++) {
						if (listbox.options[m].selected == true) {
							if (m == 0) {
								return;
							}
							listbox.options[m - 1].selected = true;
							textbox.value = listbox.options[m - 1].text;
							return;
						}
					}
				}
			}
		}

		function MoveUpAndDownTextCatID(textbox2, listbox2) {

			var f = document.theSource;
			var listbox = listbox2;
			var textbox = textbox2;

			if (event.keyCode == 13) {
				///__doPostBack('ListBox1','')
				textbox.value = "";
			}

			if (event.keyCode == '38' || event.keyCode == '40') {
				if (event.keyCode == '40') {
					for (var m = 0; m < listbox.length; m++) {
						if (listbox.options[m].selected == true) {
							if (m + 1 == listbox.length) {
								return;
							}
							listbox.options[m + 1].selected = true;
							ItemID = listbox.options[m + 1].value.toString().split('#', 2);
							textbox.value = ItemID[1];
							return;
						}
					}

					listbox.options[0].selected = true;
				}
				if (event.keyCode == '38') {
					for (var m = 0; m < listbox.length; m++) {
						if (listbox.options[m].selected == true) {
							if (m == 0) {
								return;
							}
							listbox.options[m - 1].selected = true;
							ItemID = listbox.options[m - 1].value.toString().split('#', 2);
							textbox.value = ItemID[1];
							return;
						}
					}
				}
			}
		}

		function suggestName(textbox2, listbox2, level) {
			if (isNaN(level)) { level = 1 }
			if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
				var listbox = listbox2;
				var textbox = textbox2;
				var soFar = textbox.value.toString();
				var soFarLeft = soFar.substring(0, level).toLowerCase();
				var matched = false;
				var suggestion = '';
				var m
				for (m = 0; m < listbox.length; m++) {
					suggestion = listbox.options[m].text.toString().trim();
					suggestion = suggestion.substring(0, level).toLowerCase();
					if (soFarLeft == suggestion) {
						listbox.options[m].selected = true;
						matched = true;
						break;
					}
				}
				if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
			}
		}

		function suggestNameOnCatalogID(textbox2, listbox2, level) {
			if (isNaN(level)) { level = 1 }
			if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
				var listbox = listbox2;
				var textbox = textbox2;

				var soFar = textbox.value.toString();
				var soFarLeft = soFar.substring(0, level).toLowerCase();
				var matched = false;
				var suggestion = '';
				var m
				for (m = 0; m < listbox.length; m++) {
					suggestion = listbox.options[m].value.toString().split('#', 2);
					if (suggestion[1] != '') {
						if (suggestion[1].length >= level)
							suggestionID = suggestion[1].substring(0, level).toLowerCase();
					}
					else
						suggestionID = '';
					if (soFarLeft == suggestionID) {
						listbox.options[m].selected = true;
						matched = true;
						break;
					}
				}
				if (matched && level < soFar.length) { level++; suggestNameOnCatalogID(textbox, listbox, level) }
			}
		}
	</script>
	<div id="Pbody_box_inventory">
		<Ajax:ScriptManager ID="sc" runat="server">
		</Ajax:ScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Edit Set Master</b><br />
			<asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
			</asp:Label>
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
								Sets
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlSetItem" runat="server" ToolTip="Select Sets"
								TabIndex="1">
							</asp:DropDownList>
							<input id="btnEdit" value="Edit" type="button" class="ItDoseButton" style="display: none" />
						</div>
						<div class="col-md-3">
							<label class="pull-left">
							</label>
							<b class="pull-right"></b>
						</div>
						<div class="col-md-5">
						</div>
						<div class="col-md-3">
							<label class="pull-left">
							</label>
							<b class="pull-right"></b>
						</div>
						<div class="col-md-5">
						</div>
					</div>
						<div class="row" id="p1">
							<div class="col-md-3">
								<label class="pull-left">
									Search Items
								</label>
								<b class="pull-right">:</b>
							</div>
							<div class="col-md-5">
								<asp:TextBox ID="txtitemsearch" runat="server" Style="display: none;"
									onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtitemsearch,ctl00$ContentPlaceHolder1$lstitems);"
									onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtitemsearch,ctl00$ContentPlaceHolder1$lstitems);">              
								</asp:TextBox>
								<asp:TextBox ID="txtitemsearchByCatlogID" Style="display: none;" runat="server" Width="300px" onKeyDown="MoveUpAndDownTextCatID(ctl00$ContentPlaceHolder1$txtitemsearchByCatlogID,ctl00$ContentPlaceHolder1$lstitems);" onkeyup="suggestNameOnCatalogID(ctl00$ContentPlaceHolder1$txtitemsearchByCatlogID,ctl00$ContentPlaceHolder1$lstitems);"></asp:TextBox>
							</div>
							<div class="col-md-3">
								<label class="pull-left">
								</label>
								<b class="pull-right"></b>
							</div>
							<div class="col-md-5">
							</div>
							<div class="col-md-3">
								<label class="pull-left">
								</label>
								<b class="pull-right"></b>
							</div>
							<div class="col-md-5">
							</div>
						</div>
						<div class="row" id="p2">
							<div class="col-md-3">
								<label class="pull-left">
									Items
								</label>
								<b class="pull-right">:</b>
							</div>
							<div class="col-md-10">
								<asp:ListBox ID="lstitems" runat="server" ToolTip="Select Items" Height="140px" Width="306px"
									Style="display: none; height: 140px"></asp:ListBox>
							</div>
						</div>
						<div class="row" id="p3">
							<div class="col-md-3">
								<label class="pull-left">
									Qty
								</label>
								<b class="pull-right">:</b>
							</div>
							<div class="col-md-5">
								<asp:TextBox ID="txtQty" runat="server" CssClass="ItDoseTextinputNum" MaxLength="3" Width="60px" Style="display: none;"
									onkeyup="CheckQtyRecive(this);" ToolTip="Enter Qty."></asp:TextBox>
								<cc1:FilteredTextBoxExtender ID="ftbQty" runat="server" FilterType="Numbers" TargetControlID="txtQty">
								</cc1:FilteredTextBoxExtender>
							</div>
							<div class="col-md-3">
								<label class="pull-left">
								</label>
								<b class="pull-right"></b>
							</div>
							<div class="col-md-5">
							</div>
							<div class="col-md-3">
								<label class="pull-left">
								</label>
								<b class="pull-right"></b>
							</div>
							<div class="col-md-5">
							</div>
					</div>
					<div class="row">
						<div class="col-md-11">
						</div>
						<div class="col-md-2">
							<input id="btnAdd" title="Click To Add" value="Add" type="button" class="ItDoseButton"
								style="display: none;" />
						</div>
						<div class="col-md-11">
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">Result</div>
			<table style="width: 100%; border-collapse: collapse">
				<tr>
					<td colspan="4">
						<div id="PatientLabSearchOutput" style="height: 200px; overflow: scroll;">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<table style="width: 100%; border-collapse: collapse">
			<tr>
				<td colspan="4" style="text-align: center;">&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="4" style="text-align: center;">
					<input id="btnSave" value="Save" type="button" title="Click To Save" class="ItDoseButton"
						style="display: none;" />
				</td>
			</tr>
		</table>
	</div>
	<script id="tb_PatientLabSearch" type="text/html">
	<table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
	style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Set Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:65px; display:none">Item ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:380px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Previous Qty.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">New Qty.</th>
			<th class="GridViewHeaderStyle" scope="col"  style="width:45px;">Remove</th>
		</tr>
		<#
		var dataLength=PatientData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = PatientData[j];
		  #>
					<tr id="<#=objRow.SetID#>|<#=objRow.ItemID#>" >
						<td class="GridViewLabItemStyle"><#=j+1#></td>
						<td id="SetID" class="GridViewLabItemStyle"><#=objRow.SetID#></td>
						<td id="SetName" class="GridViewLabItemStyle"><#=objRow.SetName#></td>
						<td id="ItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
						<td  id="ItemName" class="GridViewLabItemStyle"><#=objRow.ItemName#></td>
						<td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Quantity#></td>
						   
					<td  class="GridViewLabItemStyle"  style="text-align:right; ">
						 <input id="txtRecieveNew" type="text" onpaste="return false"  class="ItDoseTextinputNum" title="Enter New Qty." maxlength="3"  size="5" value="<#=objRow.Quantity#>"  onkeyup="CheckQtyRecive(this);" />
					</td>
					<td class="GridViewLabItemStyle" style="text-align:center;">
					<img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove"/>
					</td>
				</tr>
			<#}#>
	 </table>    
	</script>
</asp:Content>

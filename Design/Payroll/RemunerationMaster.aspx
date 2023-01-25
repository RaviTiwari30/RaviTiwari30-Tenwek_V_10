<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="RemunerationMaster.aspx.cs" Inherits="Design_Payroll_RemunerationMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	 
	

	<script type="text/javascript">
		$(document).ready(function () {
			bindRemuneration();
		});
		function bindRemuneration() {
			$.ajax({
				url: "Services/PayrollServices.asmx/bindRemuneration",
				data: '{}',
				type: "POST",
				async: false,
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success: function (response) {
					Remu = jQuery.parseJSON(response.d);
					if (Remu != null) {
						var output = $('#tb_SearchRemuneration').parseTemplate(Remu);
						$('#RemunerationOutput').html(output);
						$('#RemunerationOutput').show();
					}
					else {
						$('#RemunerationOutput').hide();
					}
				}
			});
		}
		function addRemuneration() {
			if ($("#btnAdd").val() == "Save")
				saveRemuneration();
			else if ($("#btnAdd").val() == "Update")
				updateRemuneration();
		}
		function saveRemuneration() {
		    $("#spnMsg").text('');
		
			if ($.trim($("#txtRemunerationName").val()) != "") {
				var type = "";
				if ($("#rdoEarnings").is(':checked')) {
				    type = "E";
				}
				else {
				    type = "D";
				}
				$.ajax({
					url: "Services/PayrollServices.asmx/addRemuneration",
					data: '{Remuneration:"' + type + '",RemunerationName:"' + $.trim($('#txtRemunerationName').val()) + '",CalType:"' + $.trim($('#ddlCaltype').val()) + '",calamtper:"' + $.trim($('#txtPerAmt').val()) + '",SequenceNo:"' + $.trim($('#txtSequenceNo').val()) + '"}',
					type: "POST",
					async: false,
					dataType: "json",
					contentType: "application/json; charset=utf-8",
					success: function (mydata) {
						var data = mydata.d;
						if (data == "1") {
						    modelAlert('Record Save Succussfully', function () {
						        $("#txtRemunerationName").val('');
						        $('#txtPerAmt').val('');
						        bindRemuneration();
						    });
						  
						}
						else if (data == "0")
						    modelAlert(' Remuneration name already exit!');
						else
						    modelAlert(' Error occured kindly contact administrator !');
						
						
					}
				});
			}
			else {
			    modelAlert('Please Enter Remuneration Head');
			}
		}
		function updateRemuneration() {
			$("#spnMsg").text('');
			if ($.trim($("#txtRemunerationName").val()) != "") {
				var type = ""; var Active = "";
				if ($("#rdoEarnings").is(':checked'))
					type = "E";
				else
					type = "D";
				if ($("#rbActive").is(':checked'))
					Active = "1";
				else
					Active = "0";
				$.ajax({
					url: "Services/PayrollServices.asmx/updateRemuneration",
					data: '{RemunerationID:"' + $.trim($('#spnRemunerationID').text()) + '",RemunerationName:"' + $.trim($('#txtRemunerationName').val()) + '",RemunerationType:"' + type + '",CalType:"' + $("#ddlCaltype").val() + '",Active:"' + Active + '",calamtper:"' + $.trim($('#txtPerAmt').val()) + '",SequenceNo:"' + $.trim($('#txtSequenceNo').val()) + '"}',
					type: "POST",
					async: false,
					dataType: "json",
					contentType: "application/json; charset=utf-8",
					success: function (mydata) {
						var data = mydata.d;
						if (data == "1")
						    modelAlert('Record Update Successfully', function () {
						        bindRemuneration();
						        cancel();
						    });
						else if (data == "0")
						    modelAlert('Item Already Exist');
						else
						    modelAlert('Error occurred, Please contact administrator');
					}
				});
			}
			else {
			    modelAlert('Please Enter Remuneration');
			}
		}

		function editRemuneration(rowid) {
			$("#spnRemunerationID").text($(rowid).closest('tr').find('#tdID').text());
			if ($(rowid).closest('tr').find('#tdType').text() == "Earnings")
				$("#rdoEarnings").prop('checked', true);
			else
				$("#rdoDeductions").prop('checked', true);
			$('#ddlCaltype').val($(rowid).closest('tr').find('#tdCalType').text());
			$('#btnAdd').val('Update');
			$('#btnCancel').show();
			$('#txtRemunerationName').val($(rowid).closest('tr').find('#tdName').text());
			$('#txtSequenceNo').val($(rowid).closest('tr').find('#tdSequence_No').text());
			if ($(rowid).closest('tr').find('#tdIsActive').text() == "Yes")
				$("#rbActive").prop('checked', true);
			else
				$("#rbDeActive").prop('checked', true);
		}

		function cancel() {
			$('#btnCancel').hide();
			$('#btnAdd').val('Add');
			$("#rdoEarnings,#rbActive").prop('checked', true);
			$("#spnRemunerationID").text('');
			$('#txtRemunerationName').val('');
			$('#txtPerAmt').val('');
			$('#ddlCaltype').prop('selectedIndex', 0);
			$('#txtSequenceNo').val('');
		}
		</script>
	<div id="Pbody_box_inventory">
		<div class="POuter_Box_Inventory" style="text-align: center">

			<b>Remuneration Master</b><br />
			<span id="spnMsg" class="ItDoseLblError"></span><br />
		</div>

		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
			Remuneration
			</div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type  
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="rdoEarnings" type="radio" name="Remuneration" value="Earnings" checked="checked" />Earnings
			                <input id="rdoDeductions" type="radio" name="Remuneration" value="Deductions" />Deductions
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Remuneration Heads 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <input type="text" id="txtRemunerationName" maxlength="20"  class="requiredField" />
                            <span id="spnRemunerationID" style="display: none"></span>
                          
                            </div>
                            <div class="col-md-2" style="display:none">
                                <label class="pull-left">
                                    CalType
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-2" style="display:none">
                                <select id="ddlCaltype">
                                    <option value="AMT">Amount</option>
                                    <option value="PER">Percent</option>
                                </select>
                            </div>
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Sequence No
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                 <input type="text" id="txtSequenceNo" onlynumber="true"  />
                            </div>
                        <div class="col-md-2" style="display:none">
                            <input type="text" id="txtPerAmt" onlynumber="true"  />
                        </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IsActive
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                             <input id="rbActive" type="radio" name="IsActive" value="Active" checked="checked" />Active
			                 <input id="rbDeActive" type="radio" name="IsActive" value="DeActive" />DeActive
                        </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
			<input type="button" value="Save" class="ItDoseButton" id="btnAdd" onclick="addRemuneration()" />
			<input type="button" value="Cancel" class="ItDoseButton" id="btnCancel" style="display:none" onclick="cancel()" />
		</div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                 <div id="RemunerationOutput" style="max-height: 400px; overflow-x: auto; text-align: center;">
                                    </div>
                </div>
	</div>
	 <script id="tb_SearchRemuneration" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_Remuneration"
	style="width:100%;border-collapse:collapse; text-align:center">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:250px;">Remuneration</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">RemunerationID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; ">Sequence No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px; display:none">CalType</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px; display:none">Amt/Per</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Active</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>
		</tr>
		<#
		var objRow;
		for(var j=0;j<Remu.length;j++)
		{
		objRow = Remu[j];
		#>
					<tr id="<#=j+1#>">
					<td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
					<td class="GridViewLabItemStyle" id="tdName"  style="width:250px;text-align:center" ><#=objRow.Name#></td>
					<td class="GridViewLabItemStyle" id="tdSequence_No"  style="width:50px;text-align:center" ><#=objRow.Sequence_No#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:50px;text-align:center;display:none" ><#=objRow.ID#></td>
					<td class="GridViewLabItemStyle" id="tdType"  style="width:50px;text-align:center" ><#=objRow.RemunerationType#></td>
					<td class="GridViewLabItemStyle" id="tdCalType"  style="width:50px;text-align:center; display:none" ><#=objRow.CalType#></td>
                        <td class="GridViewLabItemStyle" id="tdAmtPer"  style="width:50px;text-align:center; display:none" ><#=objRow.AmtPer#></td>
									   <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:50px;text-align:center" ><#=objRow.IsActive#></td>

						 <td class="GridViewLabItemStyle" style="width:30px; text-align:right">
					   <input type="button" value="Edit"  id="btnEdit"  class="ItDoseButton" onclick="editRemuneration(this);"
						 <# if(objRow.Name=="BASIC") {#>disabled="disabled"<#}#> />
					</td>
					</tr>
		<#}
		#>
	 </table>
	</script>
</asp:Content>
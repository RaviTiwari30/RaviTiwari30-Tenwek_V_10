<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ItemMaster.aspx.cs" Inherits="Design_EDP_NewItemMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script type="text/javascript" src="../../Scripts/Search.js"> </script>
	<script type="text/javascript" src="../../Scripts/Message.js" > </script>
	<script type="text/javascript">
		$(function () {
			getCategory();
			getSubCategory();
			getDepartment();
			$("#ddlCategory").bind("change", function () {
				getSubCategory();
			});
		});
		$(document).ready(function () {
			if ('<%=Util.GetString(Request.QueryString["Mode"])%>' == "1") {
				$('#divHeader').hide();
				$('#divLinks').hide();
			}
		});
		function getCategory() {
			$("#ddlCategory option").remove();
			$.ajax({
				url: "Services/Item_Master.asmx/getCategory",
				data: '{ }',
				type: "POST",
				contentType: "application/json; charset=utf-8",
				timeout: 120000,
				async: false,
				dataType: "json",
				success: function (result) {
					CategoryData = jQuery.parseJSON(result.d);
					if (CategoryData.length == 0) {
						$("#ddlCategory").append($("<option></option>").val("0").html("---No Data Found---"));
					}
					else {
						for (i = 0; i < CategoryData.length; i++) {
							$("#ddlCategory").append($("<option></option>").val(CategoryData[i].CategoryID).html(CategoryData[i].Name));
						}
						if ('<%=Util.GetString(Request.QueryString["Mode"])%>' == "1") {
							//$("#ddlCategory option:contains('Other Charges')").prop('selected', true);
							$('#ddlCategory').val('LSHHI16');
							$("#ddlCategory").prop("disabled", true);
						}
					}
				},
				error: function (xhr, status) {
					$("#ddlCategory").prop("disabled", false);
				}
			});
		}
		function getSubCategory() {
			$("#ddlSubCategory option").remove();
			$.ajax({
				url: "Services/Item_Master.asmx/getSubCategory",
				data: '{CategoryID:"' + $("#ddlCategory").val() + '" }',
				type: "POST",
				contentType: "application/json; charset=utf-8",
				timeout: 120000,
				async: false,
				dataType: "json",
				success: function (result) {
					SubCategoryData = jQuery.parseJSON(result.d);
					if (SubCategoryData.length == 0) {
						$("#ddlSubCategory").append($("<option></option>").val("0").html("---No Data Found---"));
					}
					else {
						$("#ddlSubCategory").append($("<option></option>").val("0").html(" "));
						for (i = 0; i < SubCategoryData.length; i++) {
							$("#ddlSubCategory").append($("<option></option>").val(SubCategoryData[i].SubCategoryID).html(SubCategoryData[i].Name));
						}
					}
				},
				error: function (xhr, status) {
					$("#ddlSubCategory").prop("disabled", false);
				}
			});
		}

		function getDepartment() {
			$("#ddldepartment option").remove();
			$.ajax({
				url: "Services/Item_Master.asmx/getDepartment",
				data: '{ }',
				type: "POST",
				contentType: "application/json; charset=utf-8",
				timeout: 120000,
				async: false,
				dataType: "json",
				success: function (result) {
					DepartmentData = jQuery.parseJSON(result.d);
					if (DepartmentData.length == 0) {
						$("#ddldepartment").append($("<option></option>").val("0").html("---No Data Found---"));
					}
					else {
						$("#ddldepartment").append($("<option></option>").val("0").html(" "));
						for (i = 0; i < DepartmentData.length; i++) {
							$("#ddldepartment").append($("<option></option>").val(DepartmentData[i].ID).html(DepartmentData[i].Name));
						}                      
					}
				},
				error: function (xhr, status) {
					$("#ddldepartment").prop("disabled", false);
				}
			});
		}

	</script>
	<div id="Pbody_box_inventory">
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Item Master</b>&nbsp;<br />
			<span id="spnErrorMsg" class="ItDoseLblError"></span>
			<div style="text-align: center">
				<input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
		   <input id="rdoEdit" type="radio" name="Con" value="Edit" />Edit    
			</div>

		</div>
		<div class="POuter_Box_Inventory">
			 <div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Category
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlCategory" tabindex="1" title="Select Category"></select>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Sub Category
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <select id="ddlSubCategory" tabindex="2"  title="Select Sub-Category"></select>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								Item Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <input type="text" id="txtItemName" tabindex="3" maxlength="100" title="Enter Item Name" style="width:95%"  class="requiredField" />
						 
						</div>
					</div>
						 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								CPT Code
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text"    id="txtCPTCode" tabindex="4" maxlength="50" title="Enter CPT Code" />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Department
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <select id="ddldepartment" tabindex="5" title="Select Department"  class="requiredField"></select>
							 
						</div>
						
						 <div class="col-md-3">
							<label class="pull-left">
							   Rate Editable
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input id="rdoRateYes" type="radio" name="rdoRate" value="1" />Yes
							<input id="rdoRateNo" type="radio" name="rdoRate" value="0" checked="checked" />No  
							<input id="rdoRateBoth" type="radio" name="rdoRate" value="2"  style="display:none" /><span id="spnRateBoth" style="display:none">Both</span> 
						</div>
							 
								   
						  
					</div>



				  <div class="row">

					   <div class="col-md-3">
							<label class="pull-left">
								Is Discountable
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <input id="rdoIsDisYes" type="radio" name="rdoIsDis" value="1" />Yes
							 <input id="rdoIsDisNo" type="radio" name="rdoIsDis" value="0" checked="checked" />No 
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
								 Measur Unit
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text" id="txtTypeofmeasurmentUnit" />
						</div> 
                      <div class="col-md-3">
							<label class="pull-left">
								 Measur Qty
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <input type="text" id="txtTypeofmeasurmentQty" onkeypress="return isNumber(event)" />
						</div>
						

				</div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">IsShare Ward</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           
							 <input id="rdSharedYes" type="radio" name="rdoIsShare" value="1" />Yes
							 <input id="RdSharedNo" type="radio" name="rdoIsShare" value="0" checked="checked" />No 
						
                        </div>
                    </div>
                    <div class="row">
					   <div style="display:none" class="col-md-16 trCondition">
							<div class="col-md-3">
								<label class="pull-left">
								   Condition
								</label>
								<b class="pull-right">:</b>
							</div>
							<div class="col-md-11">
								<input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
								<input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive  
								<input id="rdoBoth" type="radio" name="ActiveCon" value="2" />Both 
							</div>                             
						</div>
				   
					   


				</div>
				<div class="col-md-1"></div>
			</div>
		 

		</div>
		 </div>

		<div class="POuter_Box_Inventory">
			<div id="ItemOutput"></div>
		</div>
		<div style="text-align:center" class="POuter_Box_Inventory">
			<input type="button" id="btnSave" value="Save" tabindex="5" style="margin-top:7px"  class="ItDoseButton save" />
			<input type="button" id="btnUpdate" value="Update" style="margin-top:7px;display:none"  class="ItDoseButton save"/>
		</div>
  </div>

	<script id="tb_ItemSearch" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdItemSearch"
	style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Category</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">CategoryID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Sub Category</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">Sub CategoryID</th>                                            
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Item ID</th>

			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Department</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none">Department ID</th> 

			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">CPT Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rate Edit</th> 
            
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Measur Unit</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Measur Qty.</th> 




			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">IsDiscount</th>              
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Ishareward</th>
		</tr>
		<#       
		var dataLength=ItemData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;     
		for(var j=0;j<dataLength;j++)
		{       
		objRow = ItemData[j];
		#>
					<tr id="<#=j+1#>">                            
					<td class="GridViewLabItemStyle"><#=j+1#></td>
					<td class="GridViewLabItemStyle" id="tdCategory" style="width:140px; text-align:left"><#=objRow.Category#></td>
					<td class="GridViewLabItemStyle" id="tdCategoryID"  style="width:40px;display:none" ><#=objRow.CategoryID#></td>
					<td class="GridViewLabItemStyle" id="tdSubCategory" style="width:120px;text-align:left"><#=objRow.SubCategory#></td>
					<td class="GridViewLabItemStyle" id="tdSubCategoryID" style="width:140px; display:none"><#=objRow.SubCategoryID#></td>                                                            
					<td class="GridViewLabItemStyle" id="tdITypeName" style="width:160px;">
					   <input type="text" maxlength="100" style="width:240px" value="<#=objRow.TypeName#>" id="txtTypeName" onkeyup="CheckItem(this);" onkeypress="CheckItem(this);"/>
					   <span style="color: red; font-size: 10px;" class="shat">*</span>
					   <span id="spnTypeName" onpaste="return false" style="display:none" ><#=objRow.TypeName#> </span>
					   <span id="spnTypeCon"  style="display:none" /></td>
					<td class="GridViewLabItemStyle" id="tdItemID" style="width:140px;display:none"><#=objRow.ItemID#></td>

					<td class="GridViewLabItemStyle" id="tdDepartment" style="width:140px;text-align:left"><#=objRow.Department#></td>
					<td class="GridViewLabItemStyle" id="tdDepartmentID" style="width:50px; display:none"><#=objRow.DeptID#></td> 




					<td class="GridViewLabItemStyle" id="tdItemCode"  style="width:60px;" >                       
						<input type="text" onpaste="return false" maxlength="20" value="<#=objRow.ItemCode#>" style="width:80px" id="txtItemCode" onkeyup="CheckItemCode(this);" onkeypress="CheckItemCode(this);"/>
						<span id="spnItemCode" style="display:none" ><#=objRow.ItemCode#> </span>
						<span id="spnItemCodeCon" style="display:none"   />
					</td>
						<td class="GridViewLabItemStyle" id="tdRateEdit"  style="width:60px;">
				   <input type="radio" id="rdotdRateEditableYes" name="tdRateEditable_<#=j+1#>" value="1"
					  onclick="chkRateEditableCon(this)"    <#if(objRow.RateEditable=="1"){#> 
						checked="checked"  <#} #> />Yes                         
						 <input type="radio" id="rdotdRateEditableNo" name="tdRateEditable_<#=j+1#>" value="0"
						onclick="chkRateEditableCon(this)" <#if(objRow.RateEditable=="0"){#> 
						checked="checked"  <#} #>  />No                                               
						<span id="spnRateEditable" style="display:none"   ><#=objRow.RateEditable#></span>
						 <span id="spnRateEditableCon" style="display:none"   />
					</td>

                           
					<td class="GridViewLabItemStyle"  style="width:90px">
                        
                        <input type="text" id="tdTypeofmeasurmentUnit" value="<#=objRow.TypeofmeasurmentUnit#>"  onkeydown="CheckMeasurUnit(this)" onkeypress="CheckMeasurUnit(this)"/>
                        <span id="spnTypeofmeasurmentUnit" style="display:none"   ><#=objRow.TypeofmeasurmentUnit#></span>
<span id="spnTypeofmeasurmentUnitCon"  style="display:none" />
					</td>
					<td class="GridViewLabItemStyle"  style="width:90px;">
                        
                         <input type="text" id="tdTypeofmeasurmentQty" onkeypress="return isNumber(event)" value="<#=objRow.TypeofmeasurmentQty#>" onkeydown="CheckMeasurQty(this)" onkeyup="CheckMeasurQty(this)" />
					<span id="spnTypeofmeasurmentQty" style="display:none"   ><#=objRow.TypeofmeasurmentQty#></span>
                    <span id="spnTypeofmeasurmentQtyCon"  style="display:none" />
                    </td> 




						 <td class="GridViewLabItemStyle" id="tdIsDiscountable"  style="width:60px;">
				   <input type="radio" id="rdotdIsDisYes" name="tdIsDis_<#=j+1#>" value="1"
					  onclick="chkIsDiscountableCon(this)"    <#if(objRow.IsDiscountable=="1"){#> 
						checked="checked"  <#} #> />Yes                         
						 <input type="radio" id="rdotdIsDisNo" name="tdIsDis_<#=j+1#>" value="0"
						onclick="chkIsDiscountableCon(this)" <#if(objRow.IsDiscountable=="0"){#> 
						checked="checked"  <#} #>  />No                                               
						<span id="spnIsDiscountable" style="display:none"   ><#=objRow.IsDiscountable#></span>
						 <span id="spnIsDiscountableCon" style="display:none"   />
					</td>


					<td class="GridViewLabItemStyle" id="tdActive"  style="width:60px;">
				   <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
					  onclick="chkActiveCon(this)"    <#if(objRow.IsActive=="1"){#> 
						checked="checked"  <#} #> />Yes                         
						 <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
						onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
						checked="checked"  <#} #>  />No                                               
						<span id="spnActive" style="display:none"   ><#=objRow.IsActive#></span>
						 <span id="spnActiveCon" style="display:none"   />
					</td >
                          <td id="tdIshareward">  <input type="radio" id="rdSharedWard" name="tdSharedWardtable_<#=j+1#>" value="1"
					  onclick="chkShareWard(this)"    <#if(objRow.Isshareward=="1"){#> 
						checked="checked"  <#} #> />Yes                         
						 <input type="radio" id="rdSharedNotWard" name="tdSharedWardtable_<#=j+1#>" value="0"
						onclick="chkShareWard(this)" <#if(objRow.Isshareward=="0"){#> 
						checked="checked"  <#} #>  />No                                               
						<span id="spnIsshareward" style="display:none"   ><#=objRow.Isshareward#></span>
                              <span id="spnSharewardCon" style="display:none"   />
						 
					</td>
					</tr>           
		<#}#>                     
	 </table>    
	</script>
	<script type="text/javascript">


	    function CheckMeasurUnit (rowid) {
	        $("#spnErrorMsg").text('');

	        var txtTypeName = $.trim($(rowid).closest('tr').find('#tdTypeofmeasurmentUnit').val());
	        var spnTypeName = $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnit').html());
	        if ((txtTypeName != spnTypeName && txtTypeName!="")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html('1'));
	        }
	        else if ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1" || $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1" || ($.trim($(rowid).closest('tr').find('#spnItemCodeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnRateEditableCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
	    function CheckMeasurQty(rowid) {
	        $("#spnErrorMsg").text('');
	        var txtTypeName = $.trim($(rowid).closest('tr').find('#tdTypeofmeasurmentQty').val());
	        var spnTypeName = $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQty').html());
	        if ((txtTypeName != spnTypeName && txtTypeName != "")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html('1'));
	        }
	        else if ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1" || $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1" || ($.trim($(rowid).closest('tr').find('#spnItemCodeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnRateEditableCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
	    function CheckItem(rowid) {
	        $("#spnErrorMsg").text('');
	        var txtTypeName = $.trim($(rowid).closest('tr').find('#txtTypeName').val());
	        var spnTypeName = $.trim($(rowid).closest('tr').find('#spnTypeName').html());
	        if ((txtTypeName != spnTypeName)) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnTypeCon').html('1'));
	        }
	        else if ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1" || $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1" || ($.trim($(rowid).closest('tr').find('#spnItemCodeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnRateEditableCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnTypeCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnTypeCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
	    function CheckItemCode(rowid) {
	        $("#spnErrorMsg").text('');
	        var txtItemCode = $.trim($(rowid).closest('tr').find('#txtItemCode').val());
	        var spnItemCode = $.trim($(rowid).closest('tr').find('#spnItemCode').html());
	        if (txtItemCode != spnItemCode) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnItemCodeCon').html('1'));
	        }
	        else if ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1" || $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1" || ($.trim($(rowid).closest('tr').find('#spnTypeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnRateEditableCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnItemCodeCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnItemCodeCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
	    function chkActiveCon(rowid) {
	        $("#spnErrorMsg").text('');
	        var rdotdActive = $(rowid).closest('tr').find('#tdActive input[type=radio]:checked').val();
	        var spnActive = $.trim($(rowid).closest('tr').find('#spnActive').html());
	        if (rdotdActive != spnActive) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnActiveCon').html('1'));
	        }
	        else if ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1" || $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1" || ($.trim($(rowid).closest('tr').find('#spnTypeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnItemCodeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnRateEditableCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
	    function chkRateEditableCon(rowid) {
	        $("#spnErrorMsg").text('');
	        var rdotdRateEdit = $(rowid).closest('tr').find('#tdRateEdit input[type=radio]:checked').val();
	        var spnRateEdit = $.trim($(rowid).closest('tr').find('#spnRateEditable').html());

	        if (rdotdRateEdit != spnRateEdit) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnRateEditableCon').html('1'));
	        }
	        else if ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1" || $.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1" || ($.trim($(rowid).closest('tr').find('#spnTypeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnItemCodeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnRateEditableCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnRateEditableCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
	    function chkIsDiscountableCon(rowid) {
	        $("#spnErrorMsg").text('');
	        var rdotdIsDiscountable = $(rowid).closest('tr').find('#tdIsDiscountable input[type=radio]:checked').val();
	        var spnIsDiscountable = $.trim($(rowid).closest('tr').find('#spnIsDiscountable').html());

	        if (rdotdIsDiscountable != spnIsDiscountable) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html('1'));
	        }
	        else if (($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnTypeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnItemCodeCon').html()) == "1") || ($.trim($(rowid).closest('tr').find('#spnActiveCon').html()) == "1")) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
	            $.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html('0'));
	        }
	        else {
	            $.trim($(rowid).closest('tr').find('#spnIsDiscountableCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }
         function chkShareWard(rowid) {
	        $("#spnErrorMsg").text('');
	        var rdotdIsshareward = $(rowid).closest('tr').find('#tdIshareward input[type=radio]:checked').val();
	        var spnIsshareward = $.trim($(rowid).closest('tr').find('#spnIsshareward').html());

	        if (rdotdIsshareward != spnIsshareward) {
	            $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnSharewardCon').html('1'));
                
	            
	        }
	   
	        else {
	            $.trim($(rowid).closest('tr').find('#spnSharewardCon').html('0'));
	            $(rowid).closest('tr').css("background-color", "transparent");
	        }
	    }

		$(function () {
			$("#btnUpdate").bind("click", function () {
				$('#btnUpdate').prop('disabled', 'disabled');
				if (validateItemUpdate() == true) {
					var resultItemUpdate = itemUpdate();
					$.ajax({
						url: "Services/Item_Master.asmx/UpdateItem",
						data: JSON.stringify({ Data: resultItemUpdate }),
						type: "Post",
						contentType: "application/json; charset=utf-8",
						timeout: "120000",
						dataType: "json",
						success: function (result) {
							if (result.d == "1") {
								DisplayMsg('MM02', 'spnErrorMsg');
								$('#btnUpdate').removeProp('disabled');
								$('#ItemOutput').html('');
								$('#ItemOutput,#btnUpdate').hide();
								$('#rdoActive').prop('checked', 'checked');
								getCategory();
								getSubCategory();
								getDepartment();
							}
							else {
								DisplayMsg('MM05', 'spnErrorMsg');
							}
						},
						error: function (xhr, status) {
							DisplayMsg('MM05', 'spnErrorMsg');
						}
					});
				}
				else {
					$('#btnUpdate').removeProp('disabled');
				}
			});

	    });
	    function validateItemUpdate() {
	        var con = 0; var tableCon = 1;
	        $("#tb_grdItemSearch tr").each(function () {
	            var id = $(this).attr("id");
	            var $rowid = $(this).closest("tr");
	            if (id != "Header") {
	                if (($.trim($rowid.closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1") || ($.trim($rowid.closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1") || ($.trim($rowid.find('#spnItemCodeCon').html()) == "1") || ($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1") || ($.trim($rowid.find('#spnRateEditableCon').html()) == "1") || ($.trim($rowid.find('#spnIsDiscountableCon').html()) == "1") || ($.trim($rowid.find('#spnSharewardCon').html()) == "1")) {
	                    if ($.trim($rowid.find("#txtTypeName").val()) == "") {
	                        $("#spnErrorMsg").text('Please Enter Item Name');
	                        $rowid.find("#txtTypeName").focus();
	                        con = 1;
	                        return false;
	                    }
	                    tableCon += 1;
	                }
	            }

	        });
	        if (con == "1")
	            return false;
	        if (tableCon == "1") {
	            $("#spnErrorMsg").text('Please Change Item Name OR CPT Code OR Active Condition');
	            return false;
	        }
	        return true;
	    }
	    function itemUpdate() {
	        if ($('#tb_grdItemSearch tr').length > 0) {
	            var con = 0;
	            // $('#btnUpdate').prop('disabled', 'disabled');
	            var dataItem = new Array();
	            var ObjItem = new Object();
	            $("#tb_grdItemSearch tr").each(function () {
	                var id = $(this).attr("id");
	                var $rowid = $(this).closest("tr");
	                if (id != "Header") {
	                    if (($.trim($rowid.closest('tr').find('#spnTypeofmeasurmentUnitCon').html()) == "1") || ($.trim($rowid.closest('tr').find('#spnTypeofmeasurmentQtyCon').html()) == "1") || ($.trim($rowid.find('#spnItemCodeCon').html()) == "1") || ($.trim($rowid.find('#spnTypeCon').html()) == "1") || ($.trim($rowid.find('#spnActiveCon').html()) == "1") || ($.trim($rowid.find('#spnRateEditableCon').html()) == "1") || ($.trim($rowid.find('#spnIsDiscountableCon').html()) == "1") || ($.trim($rowid.find('#spnSharewardCon').html()) == "1")) {
	                        ObjItem.TypeName = encodeURIComponent($.trim($rowid.find("#txtTypeName").val()));
	                        ObjItem.ItemCode = encodeURIComponent($.trim($rowid.find("#txtItemCode").val()));
	                        ObjItem.SubCategoryID = $.trim($rowid.find("#tdSubCategoryID").text());
	                        ObjItem.ItemID = $.trim($rowid.find("#tdItemID").text());
	                        ObjItem.DepartmentID = $.trim($rowid.find("#tdDepartmentID").text());
	                        if ($rowid.find("#rdotdActive").is(':checked'))
	                            ObjItem.IsActive = "1";
	                        else
	                            ObjItem.IsActive = "0";
	                        if ($rowid.find("#rdotdRateEditableYes").is(':checked'))
	                            ObjItem.RateEditable = "1";
	                        else
	                            ObjItem.RateEditable = "0";

	                        if ($rowid.find("#rdotdIsDisYes").is(':checked'))
	                            ObjItem.IsDiscountable = "1";
	                        else
	                            ObjItem.IsDiscountable = "0";

	                        ObjItem.TypeofmeasurmentUnit = $.trim($rowid.find("#tdTypeofmeasurmentUnit").val());

	                        ObjItem.TypeofmeasurmentQty = $.trim($rowid.find("#tdTypeofmeasurmentQty").val());

                             if ($rowid.find("#rdSharedWard").is(':checked'))
	                            ObjItem.Isshareward = "1";
	                        else
	                            ObjItem.Isshareward = "0";

							dataItem.push(ObjItem);
							ObjItem = new Object();
						}
					}

				});
				return dataItem;
			}
		}
		function hideAllDetail() {
			$('#ItemOutput').html('');
			$('#ItemOutput,#btnUpdate').hide();
			getCategory();
			getSubCategory();
			getDepartment();
			$("#spnErrorMsg").text('');
			$('#txtItemName,#txtCPTCode').val('');
		}

		$(function () {
			if ($("#rdoNew").is(':checked')) {
				$("#btnSave").val('Save');
			}
			if ($("#rdoEdit").is(':checked')) {
				$("#btnSave").val('Search');
			}

			$("#rdoNew").bind("click", function () {
				$("#btnSave").val('Save');
				$(".trCondition").hide();
				$("#rdoRateBoth,#spnRateBoth").hide();
				$('#rdoRateNo').attr('checked', 'checked');
				$('#rdoIsDisNo').attr('checked', 'checked');
				hideAllDetail();
			});
			$("#rdoEdit").bind("click", function () {
				$("#btnSave").val('Search');
				$(".trCondition").show();
				$("#rdoRateBoth,#spnRateBoth").show();
				$('#rdoRateBoth').attr('checked', 'checked');
				hideAllDetail();
			});

			$("#btnSave").bind("click", function () {
				$("#spnErrorMsg").text('');
				$('#btnSave').prop('disabled', 'disabled');
				if ($("#btnSave").val() == "Search") {
					bindItem();
				}
				else if ($("#btnSave").val() == "Save") {

					saveItem();
				}
			});
		});

		function saveItem() {
			if (validateItem() == true) {
				var resultItem = Item();
				$.ajax({
					url: "Services/Item_Master.asmx/SaveItem",
					data: JSON.stringify({ Data: resultItem }),
					type: "POST",
					contentType: "application/json; charset=utf-8",
					timeout: 120000,
					async: false,
					dataType: "json",
					cache: false,
					success: function (result) {
						if (result.d == "1") {
							$("#spnErrorMsg").text('Record Saved Successfully');
							$('#txtItemName,#txtCPTCode').val('');
							$("#btnSave").removeProp('disabled');
						}
						else if (result.d == "2") {
							$("#spnErrorMsg").text('Item Already Exist');
							$('#txtItemName').focus();
							$("#btnSave").removeProp('disabled');
						}
						else if (result.d == "3") {
							$("#spnErrorMsg").text('CPT Code Already Exist');
							$('#txtCPTCode').focus();
							$("#btnSave").removeProp('disabled');
						}
						else {
							DisplayMsg('MM05', 'spnErrorMsg');
						}
					},
					error: function (xhr, status) {
						DisplayMsg('MM05', 'spnErrorMsg');
					}
				});
			}
			else {
				$('#btnSave').removeProp('disabled');
			}
		}
		function Item() {
			var data = new Array();
			var objItem = new Object();
			objItem.TypeName = encodeURIComponent($.trim($('#txtItemName').val()));
			objItem.SubCategoryID = $('#ddlSubCategory').val();
			objItem.ItemCode = encodeURIComponent($.trim($('#txtCPTCode').val()));
			objItem.DepartmentID = $('#ddldepartment').val();

			if ($("#rdoRateYes").is(':checked'))
				objItem.RateEditable = "1";
			else
				objItem.RateEditable = "0";

			if ($("#rdoIsDisYes").is(':checked'))
				objItem.IsDiscountable = "1";
			else
				objItem.IsDiscountable = "0";

	        objItem.TypeofmeasurmentUnit = $("#txtTypeofmeasurmentUnit").val();

	        objItem.TypeofmeasurmentQty = $("#txtTypeofmeasurmentQty").val();
	        if ($("#rdoIsShare").is(':checked'))
	            objItem.Isshareward = "1";
	        else
	            objItem.Isshareward = "0";
			data.push(objItem);
			return data;
		}
		function validateItem() {
			if ($("#ddlCategory").val() == "0") {
				$("#spnErrorMsg").text('Please Select Category');
				$("#ddlCategory").focus();
				return false;
			}
			if ($("#ddlSubCategory").val() == "0") {
				$("#spnErrorMsg").text('Please Select SubCategory');
				$("#ddlSubCategory").focus();
				return false;
			}
			if ($("#txtItemName").val() == "") {
				$("#spnErrorMsg").text('Please Enter Item Name');
				$("#txtItemName").focus();
				return false;
			}
			if ($("#ddldepartment").val() == "0") {
				$("#spnErrorMsg").text('Please Select Department');
				$("#ddldepartment").focus();
				return false;
			}


			return true;
		}
		function bindItem() {
			$.ajax({
				url: "services/Item_Master.asmx/LoadItems",
				data: '{CategoryID:"' + $("#ddlCategory").val() + '",SubCategoryID:"' + $("#ddlSubCategory").val() + '",ItemName:"' + $("#txtItemName").val() + '",CPTCode:"' + $("#txtCPTCode").val() + '",Type:"' + $('input[name=ActiveCon]:checked').val() + '",RateEditable:"' + $('input[name=rdoRate]:checked').val() + '",DepartmentID:"' + $("#ddldepartment").val() + '",IsDiscountable:"' + $('input[name=rdoIsDis]:checked').val() + '"}',
				type: "POST",
				contentType: "application/json; charset=utf-8",
				timeout: 120000,
				async: true,
				dataType: "json",
				success: function (result) {
					if (result.d != "") {
						ItemData = jQuery.parseJSON(result.d);
						if (ItemData != null) {
							var output = $('#tb_ItemSearch').parseTemplate(ItemData);
							$('#ItemOutput').html(output);
							$('#ItemOutput,#btnUpdate').show();
							$('#btnSave').removeProp('disabled');
						}
					}
					else {
						$('#ItemOutput').html();
						$('#ItemOutput,#btnUpdate').hide();
						DisplayMsg('MM04', 'spnErrorMsg');
						$('#btnSave').removeProp('disabled');
					}
				},
				error: function (xhr, status) {
					$('#ItemOutput').html();
					$('#ItemOutput').hide();
					DisplayMsg('MM05', 'spnErrorMsg');
				}
			});
		}
	    function isNumber(evt) {
	        evt = (evt) ? evt : window.event;
	        var charCode = (evt.which) ? evt.which : evt.keyCode;
	        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
	            return false;
	        }
	        return true;
	    }
	</script>
</asp:Content>


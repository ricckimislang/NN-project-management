<script setup>
import { Card } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { DropdownMenuItem } from '@/components/ui/dropdown-menu'
import AppDropdownMenu from '@/components/layout/AppDropdownMenu.vue'
</script>

<template>
  <Card class="p-4">
    <div class="flex items-center space-x-4">
      <div class="flex items-center space-x-3">
        <div class="w-10 h-10 rounded-lg bg-muted flex items-center justify-center">
          <span class="text-muted-foreground">🏢</span>
        </div>
      </div>

      <div class="space-y-2">
        <div class="space-y-1">
          <h3 class="text-base font-semibold text-foreground">Downtown Office Renovation</h3>
          <p class="text-xs text-muted-foreground">Renovation</p>
        </div>
        <div class="space-x-1">
          <p class="text-xs text-muted-foreground">📅 Jan 15, 2024 - Jun 30, 2024</p>
          <p class="text-xs text-muted-foreground">👥 Sarah Johnson</p>
        </div>
      </div>

      <div class="flex-1">
        <div class="flex justify-between text-xs mb-1">
          <span>Progress</span>
          <span>65%</span>
        </div>
        <Progress :value="65" />
      </div>

      <div class="flex justify-between items-center space-x-2">
        <Badge variant="success">Active</Badge>
      </div>
      <AppDropdownMenu>
        <template #trigger>
          <Button variant="ghost" size="sm">
            <i class="fa-solid fa-ellipsis-vertical"></i>
          </Button>
        </template>
        <template #content>
          <DropdownMenuItem>View</DropdownMenuItem>
          <DropdownMenuItem>Edit</DropdownMenuItem>
          <DropdownMenuItem>Archive</DropdownMenuItem>
          <DropdownMenuItem class="text-destructive">Delete</DropdownMenuItem>
        </template>
      </AppDropdownMenu>
    </div>
  </Card>
</template>

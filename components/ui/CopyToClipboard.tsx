'use client';
import { cn, copyToClipboard } from '@/lib/utils';
import { CheckIcon, CopyIcon, XIcon } from 'lucide-react';
import { useOptimistic, useTransition } from 'react';

export const CopyToClipboard = ({
  getText,
  iconSize = 12,
  className,
  timeout = 1200,
  ...props
}: {
  getText: () => string;
  timeout?: number;
  iconSize?: number;
} & React.ComponentProps<'button'>) => {
  const [state, setState] = useOptimistic<'idle' | 'copied' | 'failed'>('idle');
  const [, startTransition] = useTransition();

  return (
    <button
      onClick={() => {
        startTransition(async () => {
          try {
            await copyToClipboard(getText());
            setState('copied');
          } catch (error) {
            console.error('Error copying to clipboard', error);
            setState('failed');
          }
          await new Promise((resolve) => setTimeout(resolve, timeout));
        });
      }}
      className={cn(
        `icon-btn h-7 w-7 cursor-pointer ${
          state === 'copied'
            ? 'bg-emerald-500/15 border-emerald-300/30 text-emerald-100'
            : state === 'failed'
              ? 'bg-blue-500/15 border-blue-300/30 text-blue-100'
              : ''
        } accent-focus`,
        className,
      )}
      {...props}
    >
      {state === 'idle' ? (
        <CopyIcon size={iconSize} />
      ) : state === 'copied' ? (
        <CheckIcon size={iconSize} />
      ) : (
        <XIcon size={iconSize} />
      )}
    </button>
  );
};
